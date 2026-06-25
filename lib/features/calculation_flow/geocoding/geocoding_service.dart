import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as native_geo;

import 'package:rectify/data/models/geo_place.dart';
import 'package:rectify/providers/core_providers.dart';

/// Geocoding service contract (`docs/implementation-plan.md` §7.2 /
/// §14 Phase 4 / §9.8).
///
/// Production builds can wire a public, app-restricted geocoding provider
/// through `RECTIFY_GEOCODING_*`. Builds without geocoding config use the
/// platform geocoder first, then keep the in-memory fallback so the input
/// remains usable in offline/demo contexts.
abstract class GeocodingService {
  /// Suggest up to 5 [GeoPlace] hits for [query].
  ///
  /// `query` may be empty; implementations should return an empty
  /// list rather than throwing.
  Future<List<GeoPlace>> search(String query);
}

enum _GeocodingBackend { mapbox, nominatim }

/// HTTP-backed geocoder for global city/place search.
///
/// Mapbox is used when a public `pk...` client token is configured. A
/// Nominatim-compatible endpoint is supported only when explicitly supplied as
/// a base URL, which lets us point at an owner-controlled proxy/self-hosted
/// instance rather than silently depending on a public autocomplete service.
class HttpGeocodingService implements GeocodingService {
  HttpGeocodingService.mapbox(
    Dio dio, {
    required String publicKey,
  }) : this._(dio, _GeocodingBackend.mapbox, publicKey);

  HttpGeocodingService.nominatim(Dio dio)
    : this._(dio, _GeocodingBackend.nominatim, null);

  HttpGeocodingService._(this._dio, this._backend, this._publicKey);

  final Dio _dio;
  final _GeocodingBackend _backend;
  final String? _publicKey;

  @override
  Future<List<GeoPlace>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const <GeoPlace>[];

    try {
      return switch (_backend) {
        _GeocodingBackend.mapbox => await _searchMapbox(trimmed),
        _GeocodingBackend.nominatim => await _searchNominatim(trimmed),
      };
    } on DioException {
      return const <GeoPlace>[];
    } on FormatException {
      return const <GeoPlace>[];
    }
  }

  Future<List<GeoPlace>> _searchMapbox(String query) async {
    final response = await _dio.get<Object?>(
      '/geocoding/v5/mapbox.places/${Uri.encodeComponent(query)}.json',
      queryParameters: <String, Object?>{
        'access_token': _publicKey,
        'limit': 5,
        'types': 'place,locality',
        if (_containsCyrillic(query)) 'language': 'uk,en',
      },
    );
    return _parseMapbox(response.data);
  }

  Future<List<GeoPlace>> _searchNominatim(String query) async {
    final response = await _dio.get<Object?>(
      '/search',
      queryParameters: <String, Object?>{
        'q': query,
        'format': 'jsonv2',
        'addressdetails': 1,
        'limit': 5,
      },
      options: Options(
        headers: <String, Object?>{
          if (_containsCyrillic(query)) 'Accept-Language': 'uk,en',
        },
      ),
    );
    return _parseNominatim(response.data);
  }

  static List<GeoPlace> _parseNominatim(Object? data) {
    final entries = _objectList(data);
    return entries
        .map(_parseNominatimPlace)
        .nonNulls
        .take(5)
        .toList(growable: false);
  }

  static GeoPlace? _parseNominatimPlace(Object? raw) {
    final map = _stringMap(raw);
    if (map.isEmpty) return null;

    final latitude = _readDouble(map['lat']);
    final longitude = _readDouble(map['lon']);
    if (latitude == null || longitude == null) return null;

    final address = _stringMap(map['address']);
    final fallbackDisplay = _readString(map['display_name']) ?? '';
    final name =
        _firstAddressValue(address, const <String>[
          'city',
          'town',
          'village',
          'municipality',
          'hamlet',
          'county',
        ]) ??
        _readString(map['name']) ??
        _firstSegment(fallbackDisplay);
    final country =
        _readString(address['country']) ?? _lastSegment(fallbackDisplay);
    final region = _firstAddressValue(address, const <String>[
      'state',
      'region',
      'province',
      'county',
    ]);
    final displayName = _displayName(
      name: name,
      country: country,
      fallback: fallbackDisplay,
    );

    if (displayName.isEmpty) return null;
    return GeoPlace(
      displayName: displayName,
      country: country ?? displayName,
      latitude: latitude,
      longitude: longitude,
      region: region,
    );
  }

  static List<GeoPlace> _parseMapbox(Object? data) {
    final root = _stringMap(data);
    final features = _objectList(root['features']);
    return features
        .map(_parseMapboxFeature)
        .nonNulls
        .take(5)
        .toList(growable: false);
  }

  static GeoPlace? _parseMapboxFeature(Object? raw) {
    final map = _stringMap(raw);
    if (map.isEmpty) return null;

    final center = _objectList(map['center']);
    if (center.length < 2) return null;
    final longitude = _readDouble(center[0]);
    final latitude = _readDouble(center[1]);
    if (latitude == null || longitude == null) return null;

    final fallbackDisplay = _readString(map['place_name']) ?? '';
    final context = _objectList(map['context']);
    final country =
        _mapboxContextText(context, 'country') ?? _lastSegment(fallbackDisplay);
    final region =
        _mapboxContextText(context, 'region') ??
        _mapboxContextText(context, 'district') ??
        _mapboxContextText(context, 'place');
    final name = _readString(map['text']) ?? _firstSegment(fallbackDisplay);
    final displayName = _displayName(
      name: name,
      country: country,
      fallback: fallbackDisplay,
    );

    if (displayName.isEmpty) return null;
    return GeoPlace(
      displayName: displayName,
      country: country ?? displayName,
      latitude: latitude,
      longitude: longitude,
      region: region,
    );
  }
}

typedef NativeLocationLookup =
    Future<List<native_geo.Location>> Function(String address);
typedef NativePlacemarkLookup =
    Future<List<native_geo.Placemark>> Function(
      double latitude,
      double longitude,
    );

/// Geocoder backed by the platform implementation supplied by iOS/Android.
///
/// The package returns coordinates only, so the user-entered text remains the
/// display value. That is still enough to unblock live calculations because
/// the rectification request needs resolved latitude/longitude.
class NativePlatformGeocodingService implements GeocodingService {
  NativePlatformGeocodingService({
    this.locationFromAddress = native_geo.locationFromAddress,
    this.placemarkFromCoordinates = native_geo.placemarkFromCoordinates,
  });

  final NativeLocationLookup locationFromAddress;
  final NativePlacemarkLookup placemarkFromCoordinates;

  @override
  Future<List<GeoPlace>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const <GeoPlace>[];
    if (_isTooShortNativeQuery(trimmed)) return const <GeoPlace>[];

    try {
      final locations = await locationFromAddress(trimmed);
      final places = <GeoPlace>[];
      for (final location in locations) {
        if (!_hasUsableCoordinates(location.latitude, location.longitude)) {
          continue;
        }
        final place = await _placeFromNativeLocation(location);
        if (place == null) continue;
        places.add(place);
        if (places.length == 5) break;
      }
      return places;
    } on native_geo.NoResultFoundException {
      return const <GeoPlace>[];
    } on PlatformException {
      return const <GeoPlace>[];
    } on MissingPluginException {
      return const <GeoPlace>[];
    } on Exception {
      return const <GeoPlace>[];
    }
  }

  Future<GeoPlace?> _placeFromNativeLocation(
    native_geo.Location location,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      for (final placemark in placemarks) {
        final city = _firstNativePlacemarkValue(
          placemark.locality,
          placemark.subLocality,
          placemark.name,
        );
        final country = _readString(placemark.country);
        if (city == null || country == null) continue;
        final region = _firstNativePlacemarkValue(
          placemark.administrativeArea,
          placemark.subAdministrativeArea,
        );
        return GeoPlace(
          displayName: _displayName(
            name: city,
            country: country,
            fallback: city,
          ),
          country: country,
          latitude: location.latitude,
          longitude: location.longitude,
          region: region,
        );
      }
      return null;
    } on native_geo.NoResultFoundException {
      return null;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    } on Exception {
      return null;
    }
  }
}

/// Tries [primary] first and uses [fallback] only when the primary source
/// returns no usable coordinates.
class FallbackGeocodingService implements GeocodingService {
  const FallbackGeocodingService({
    required this.primary,
    required this.fallback,
  });

  final GeocodingService primary;
  final GeocodingService fallback;

  @override
  Future<List<GeoPlace>> search(String query) async {
    final primaryResults = await primary.search(query);
    if (primaryResults.isNotEmpty) return primaryResults;
    return fallback.search(query);
  }
}

/// In-memory fallback used when the platform geocoder is unavailable. It keeps
/// the demo walkthrough available, but real global city search should resolve
/// through configured HTTP geocoding or the native platform geocoder first.
class StubGeocodingService implements GeocodingService {
  const StubGeocodingService();

  static const _entries = <_StubEntry>[
    _StubEntry(
      GeoPlace(
        displayName: 'Kyiv, Ukraine',
        country: 'Ukraine',
        latitude: 50.4501,
        longitude: 30.5234,
      ),
      <String>['kyiv', 'київ', 'киев'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Kharkiv, Ukraine',
        country: 'Ukraine',
        latitude: 49.9935,
        longitude: 36.2304,
        region: 'Kharkiv Oblast',
      ),
      // Ukrainian, Russian, and older-transliteration spellings all match.
      <String>['kharkiv', 'kharkov', 'харків', 'харьков'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Liubotyn, Ukraine',
        country: 'Ukraine',
        latitude: 49.9565,
        longitude: 35.9246,
        region: 'Kharkiv Oblast',
      ),
      // люботин = correct Ukrainian; любатин = common user misspelling.
      <String>['liubotyn', 'lyubotyn', 'люботин', 'любатин'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'London, United Kingdom',
        country: 'United Kingdom',
        latitude: 51.5074,
        longitude: -0.1278,
      ),
      <String>['london'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'New York, United States',
        country: 'United States',
        latitude: 40.7128,
        longitude: -74.006,
        region: 'NY',
      ),
      <String>['new york', 'new-york', 'nyc'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Los Angeles, United States',
        country: 'United States',
        latitude: 34.0522,
        longitude: -118.2437,
        region: 'CA',
      ),
      <String>['los angeles', 'la'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Berlin, Germany',
        country: 'Germany',
        latitude: 52.52,
        longitude: 13.405,
      ),
      <String>['berlin'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Paris, France',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522,
      ),
      <String>['paris'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Tokyo, Japan',
        country: 'Japan',
        latitude: 35.6762,
        longitude: 139.6503,
      ),
      <String>['tokyo'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Mumbai, India',
        country: 'India',
        latitude: 19.076,
        longitude: 72.8777,
      ),
      <String>['mumbai', 'bombay'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Sao Paulo, Brazil',
        country: 'Brazil',
        latitude: -23.5505,
        longitude: -46.6333,
      ),
      <String>['sao paulo', 'são paulo'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Sydney, Australia',
        country: 'Australia',
        latitude: -33.8688,
        longitude: 151.2093,
      ),
      <String>['sydney'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Toronto, Canada',
        country: 'Canada',
        latitude: 43.6532,
        longitude: -79.3832,
      ),
      <String>['toronto'],
    ),
    _StubEntry(
      GeoPlace(
        displayName: 'Mexico City, Mexico',
        country: 'Mexico',
        latitude: 19.4326,
        longitude: -99.1332,
      ),
      <String>['mexico city', 'ciudad de mexico', 'cdmx'],
    ),
  ];

  @override
  Future<List<GeoPlace>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const <GeoPlace>[];
    final needle = trimmed.toLowerCase();
    return _entries
        .where(
          (e) =>
              e.place.displayName.toLowerCase().contains(needle) ||
              e.aliases.any((alias) => alias.contains(needle)),
        )
        .map((e) => e.place)
        .take(5)
        .toList(growable: false);
  }
}

class _StubEntry {
  const _StubEntry(this.place, this.aliases);
  final GeoPlace place;
  final List<String> aliases;
}

/// Riverpod handle for the geocoder. Override in tests with
/// `ProviderScope(overrides: [...])` against
/// [geocodingServiceProvider].
final geocodingServiceProvider = Provider<GeocodingService>((ref) {
  final config = ref.watch(buildConfigProvider);
  final publicKey = config.geocodingPublicKey.trim();
  final configuredBaseUrl = config.geocodingBaseUrl.trim();

  if (publicKey.isNotEmpty) {
    final baseUrl = configuredBaseUrl.isEmpty
        ? 'https://api.mapbox.com'
        : configuredBaseUrl;
    final dio = _buildGeocodingDio(
      baseUrl: _trimTrailingSlash(baseUrl),
      timeout: config.requestTimeout,
    );
    ref.onDispose(dio.close);
    return HttpGeocodingService.mapbox(dio, publicKey: publicKey);
  }

  if (configuredBaseUrl.isNotEmpty) {
    final dio = _buildGeocodingDio(
      baseUrl: _trimTrailingSlash(configuredBaseUrl),
      timeout: config.requestTimeout,
    );
    ref.onDispose(dio.close);
    return HttpGeocodingService.nominatim(dio);
  }

  return FallbackGeocodingService(
    primary: NativePlatformGeocodingService(),
    fallback: const StubGeocodingService(),
  );
});

Dio _buildGeocodingDio({
  required String baseUrl,
  required Duration timeout,
}) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      headers: const <String, Object>{
        'Accept': 'application/json',
        'User-Agent': 'TrueRise mobile geocoder (https://truerise.com.ua)',
      },
    ),
  );
}

String _trimTrailingSlash(String value) {
  var trimmed = value.trim();
  while (trimmed.endsWith('/')) {
    trimmed = trimmed.substring(0, trimmed.length - 1);
  }
  return trimmed;
}

bool _containsCyrillic(String value) {
  for (final codeUnit in value.codeUnits) {
    if (codeUnit >= 0x0400 && codeUnit <= 0x04FF) return true;
  }
  return false;
}

List<Object?> _objectList(Object? value) {
  if (value is List<Object?>) return value;
  return const <Object?>[];
}

Map<String, Object?> _stringMap(Object? value) {
  if (value is! Map<Object?, Object?>) return const <String, Object?>{};
  return <String, Object?>{
    for (final entry in value.entries)
      if (entry.key != null) entry.key.toString(): entry.value,
  };
}

String? _readString(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

double? _readDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool _hasUsableCoordinates(double latitude, double longitude) {
  return latitude.isFinite &&
      longitude.isFinite &&
      (latitude != 0 || longitude != 0);
}

bool _isTooShortNativeQuery(String value) {
  return value.runes.length < 3;
}

String? _firstNativePlacemarkValue(
  String? first, [
  String? second,
  String? third,
]) {
  return _readString(first) ?? _readString(second) ?? _readString(third);
}

String? _firstAddressValue(
  Map<String, Object?> address,
  List<String> keys,
) {
  for (final key in keys) {
    final value = _readString(address[key]);
    if (value != null) return value;
  }
  return null;
}

String? _mapboxContextText(List<Object?> context, String idPrefix) {
  for (final raw in context) {
    final item = _stringMap(raw);
    final id = _readString(item['id']);
    if (id == null || !id.startsWith('$idPrefix.')) continue;
    final text = _readString(item['text']);
    if (text != null) return text;
  }
  return null;
}

String? _firstSegment(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return _readString(trimmed.split(',').first);
}

String? _lastSegment(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return _readString(trimmed.split(',').last);
}

String _displayName({
  required String? name,
  required String? country,
  required String fallback,
}) {
  final safeFallback = fallback.trim();
  if (name == null || country == null) return safeFallback;
  if (name.toLowerCase() == country.toLowerCase()) return name;
  return '$name, $country';
}
