import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart' as native_geo;
import 'package:rectify/data/models/geo_place.dart';
import 'package:rectify/features/calculation_flow/geocoding/geocoding_service.dart';
import 'package:rectify/providers/core_providers.dart';

import '../../../data/api/fake_http_adapter.dart';

const _defaultBuildConfig = RectifyBuildConfig(
  proxyBaseUrl: 'https://api-public.astrology-api.io',
  proxyAppId: '',
  proxyPath: '/api/v3/rectification/search',
  providerBaseUrl: 'https://api.astrology-api.io',
  providerPath: '/api/v3/rectification/search',
  geocodingBaseUrl: '',
  geocodingPublicKey: '',
  env: 'test',
);

void main() {
  group('StubGeocodingService', () {
    const service = StubGeocodingService();

    test('returns empty list for blank query', () async {
      expect(await service.search(''), isEmpty);
      expect(await service.search('   '), isEmpty);
    });

    test('matches well-known English-named cities', () async {
      final london = await service.search('London');
      expect(london, isNotEmpty);
      expect(london.first.latitude, isNonZero);
      expect(london.first.longitude, isNonZero);

      final kyiv = await service.search('Kyiv');
      expect(kyiv, isNotEmpty);
      expect(kyiv.first.latitude, isNonZero);
      expect(kyiv.first.longitude, isNonZero);
    });

    test('returns Kharkiv for Ukrainian Cyrillic spelling Харків', () async {
      final results = await service.search('Харків');
      expect(
        results,
        isNotEmpty,
        reason: 'Харків (Ukrainian) must match Kharkiv in stub',
      );
      expect(results.first.latitude, isNonZero);
      expect(results.first.longitude, isNonZero);
    });

    test('returns Kharkiv for Russian Cyrillic spelling Харьков', () async {
      final results = await service.search('Харьков');
      expect(
        results,
        isNotEmpty,
        reason: 'Харьков (Russian) must match Kharkiv in stub',
      );
      expect(results.first.latitude, isNonZero);
      expect(results.first.longitude, isNonZero);
    });

    test('returns Kharkiv for Latin transliteration Kharkiv', () async {
      final results = await service.search('Kharkiv');
      expect(results, isNotEmpty);
      expect(results.first.latitude, isNonZero);
      expect(results.first.longitude, isNonZero);
    });

    test('returns Liubotyn for Ukrainian Cyrillic spelling Люботин', () async {
      final results = await service.search('Люботин');
      expect(
        results,
        isNotEmpty,
        reason: 'Люботин (Ukrainian) must match Liubotyn in stub',
      );
      expect(results.first.latitude, isNonZero);
      expect(results.first.longitude, isNonZero);
    });

    test(
      'returns Liubotyn for common user misspelling Любатин',
      () async {
        final results = await service.search('Любатин');
        expect(
          results,
          isNotEmpty,
          reason: 'Любатин (misspelling of Люботин) must still match',
        );
        expect(results.first.latitude, isNonZero);
        expect(results.first.longitude, isNonZero);
      },
    );

    test('returns Liubotyn for Latin transliteration Liubotyn', () async {
      final results = await service.search('Liubotyn');
      expect(results, isNotEmpty);
      expect(results.first.latitude, isNonZero);
      expect(results.first.longitude, isNonZero);
    });

    test(
      'returns a GeoPlace with non-zero coords that unblocks live mode',
      () async {
        final results = await service.search('Харків');
        expect(results, isNotEmpty);
        final place = results.first;
        // Verify the place is usable to unblock live mode:
        // lat and lon must be non-null and non-zero.
        expect(place.latitude, isNot(0.0));
        expect(place.longitude, isNot(0.0));
      },
    );
  });

  group('NativePlatformGeocodingService', () {
    test(
      'enriches native coordinates with city country and region',
      () async {
        final service = NativePlatformGeocodingService(
          locationFromAddress: (address) async {
            expect(address, 'Мукачево');
            return <native_geo.Location>[
              native_geo.Location(
                latitude: 48.4425,
                longitude: 22.718,
                timestamp: DateTime.utc(2026),
              ),
            ];
          },
          placemarkFromCoordinates: (latitude, longitude) async {
            expect(latitude, 48.4425);
            expect(longitude, 22.718);
            return const <native_geo.Placemark>[
              native_geo.Placemark(
                locality: 'Мукачево',
                administrativeArea: 'Закарпатська область',
                country: 'Україна',
              ),
            ];
          },
        );

        final places = await service.search(' Мукачево ');

        expect(places, hasLength(1));
        expect(places.single.displayName, 'Мукачево, Україна');
        expect(places.single.country, 'Україна');
        expect(places.single.region, 'Закарпатська область');
        expect(places.single.latitude, 48.4425);
        expect(places.single.longitude, 22.718);
      },
    );

    test(
      'returns empty without native lookup for too-short ambiguous input',
      () async {
        var queriedNative = false;
        final service = NativePlatformGeocodingService(
          locationFromAddress: (_) async {
            queriedNative = true;
            return <native_geo.Location>[
              native_geo.Location(
                latitude: 48.4425,
                longitude: 22.718,
                timestamp: DateTime.utc(2026),
              ),
            ];
          },
        );

        await expectLater(service.search('МУ'), completion(isEmpty));
        expect(queriedNative, isFalse);
      },
    );

    test(
      'returns empty instead of throwing when native lookup has no result',
      () async {
        final service = NativePlatformGeocodingService(
          locationFromAddress: (_) async {
            throw const native_geo.NoResultFoundException();
          },
        );

        await expectLater(
          service.search('Missing village'),
          completion(isEmpty),
        );
      },
    );

    test('drops unusable native coordinates', () async {
      final service = NativePlatformGeocodingService(
        locationFromAddress: (_) async {
          return <native_geo.Location>[
            native_geo.Location(
              latitude: 0,
              longitude: 0,
              timestamp: DateTime.utc(2026),
            ),
          ];
        },
      );

      await expectLater(service.search('Null Island'), completion(isEmpty));
    });
  });

  group('FallbackGeocodingService', () {
    test(
      'returns native results without touching the offline fallback',
      () async {
        final nativeResults = <GeoPlace>[
          const GeoPlace(
            displayName: 'Poltava',
            country: 'Ukraine',
            latitude: 49.5883,
            longitude: 34.5514,
          ),
        ];
        final fallbackResults = <GeoPlace>[
          const GeoPlace(
            displayName: 'Kyiv, Ukraine',
            country: 'Ukraine',
            latitude: 50.4501,
            longitude: 30.5234,
          ),
        ];
        final primary = _FakeGeocodingService(nativeResults);
        final fallback = _FakeGeocodingService(fallbackResults);
        final service = FallbackGeocodingService(
          primary: primary,
          fallback: fallback,
        );

        final places = await service.search('Poltava');

        expect(places, nativeResults);
        expect(primary.queries, <String>['Poltava']);
        expect(fallback.queries, isEmpty);
      },
    );

    test(
      'falls back to the offline stub when native lookup returns no hits',
      () async {
        final service = FallbackGeocodingService(
          primary: _FakeGeocodingService(const <GeoPlace>[]),
          fallback: const StubGeocodingService(),
        );

        final places = await service.search('Kyiv');

        expect(places, isNotEmpty);
        expect(places.first.displayName, 'Kyiv, Ukraine');
      },
    );
  });

  group('geocodingServiceProvider', () {
    test('uses native platform lookup before the offline stub by default', () {
      final container = ProviderContainer(
        overrides: [
          buildConfigProvider.overrideWithValue(_defaultBuildConfig),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(geocodingServiceProvider),
        isA<FallbackGeocodingService>(),
      );
    });
  });

  group('HttpGeocodingService', () {
    test('queries a Nominatim-compatible endpoint with unicode text', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueJson('''
[
  {
    "display_name": "Харків, Харківська область, Україна",
    "name": "Харків",
    "lat": "49.9935",
    "lon": "36.2304",
    "address": {
      "city": "Харків",
      "state": "Харківська область",
      "country": "Україна"
    }
  }
]
''');
      final dio = Dio(BaseOptions(baseUrl: 'https://geo.example.test'))
        ..httpClientAdapter = adapter;
      final service = HttpGeocodingService.nominatim(dio);

      final places = await service.search('Хар');

      expect(adapter.requests, hasLength(1));
      final request = adapter.requests.single;
      expect(request.method, 'GET');
      expect(request.uri.path, '/search');
      expect(request.uri.queryParameters['q'], 'Хар');
      expect(request.uri.queryParameters['format'], 'jsonv2');
      expect(request.uri.queryParameters['addressdetails'], '1');
      expect(request.uri.queryParameters['limit'], '5');
      expect(request.headers['accept-language'], <String>['uk,en']);
      expect(places, hasLength(1));
      expect(places.single.displayName, 'Харків, Україна');
      expect(places.single.country, 'Україна');
      expect(places.single.region, 'Харківська область');
      expect(places.single.latitude, 49.9935);
      expect(places.single.longitude, 36.2304);
    });

    test('queries Mapbox when a public client key is configured', () async {
      final adapter = FakeHttpAdapter()
        ..enqueueJson('''
{
  "features": [
    {
      "place_name": "Tokyo, Tokyo, Japan",
      "text": "Tokyo",
      "center": [139.6917, 35.6895],
      "context": [
        {"id": "region.1", "text": "Tokyo"},
        {"id": "country.1", "text": "Japan"}
      ]
    }
  ]
}
''');
      final dio = Dio(BaseOptions(baseUrl: 'https://api.mapbox.com'))
        ..httpClientAdapter = adapter;
      final service = HttpGeocodingService.mapbox(
        dio,
        publicKey: 'pk.test',
      );

      final places = await service.search('Tokyo');

      expect(adapter.requests, hasLength(1));
      final request = adapter.requests.single;
      expect(request.method, 'GET');
      expect(request.uri.path, '/geocoding/v5/mapbox.places/Tokyo.json');
      expect(request.uri.queryParameters['access_token'], 'pk.test');
      expect(request.uri.queryParameters['limit'], '5');
      expect(request.uri.queryParameters['types'], 'place,locality');
      expect(places, hasLength(1));
      expect(places.single.displayName, 'Tokyo, Japan');
      expect(places.single.country, 'Japan');
      expect(places.single.region, 'Tokyo');
      expect(places.single.latitude, 35.6895);
      expect(places.single.longitude, 139.6917);
    });

    test(
      'returns an empty list instead of throwing on transport failure',
      () async {
        final adapter = FakeHttpAdapter()
          ..enqueueTransportFailure(DioExceptionType.connectionError);
        final dio = Dio(BaseOptions(baseUrl: 'https://geo.example.test'))
          ..httpClientAdapter = adapter;
        final service = HttpGeocodingService.nominatim(dio);

        await expectLater(service.search('Paris'), completion(isEmpty));
      },
    );
  });
}

class _FakeGeocodingService implements GeocodingService {
  _FakeGeocodingService(this._results);

  final List<GeoPlace> _results;
  final queries = <String>[];

  @override
  Future<List<GeoPlace>> search(String query) async {
    queries.add(query);
    return _results;
  }
}
