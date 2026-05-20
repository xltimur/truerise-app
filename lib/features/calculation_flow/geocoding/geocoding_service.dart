import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/data/models/geo_place.dart';

/// Geocoding service contract (`docs/implementation-plan.md` §7.2 /
/// §14 Phase 4).
///
/// Phase 4 ships an in-memory stub so the Birth Data screen has a
/// working city picker without depending on a third-party HTTP API.
/// Real provider selection (Nominatim / Mapbox / Google Places) and
/// network wiring lands in Phase 6 once API keys and rate-limit
/// policies are decided.
abstract class GeocodingService {
  /// Suggest up to 5 [GeoPlace] hits for [query].
  ///
  /// `query` may be empty; implementations should return an empty
  /// list rather than throwing.
  Future<List<GeoPlace>> search(String query);
}

/// In-memory geocoder used by the Phase 4 demo flow. Returns a tiny
/// hard-coded city list filtered by case-insensitive substring match.
/// Sufficient for the input flow walk-through; no network calls.
class StubGeocodingService implements GeocodingService {
  const StubGeocodingService();

  static const _places = <GeoPlace>[
    GeoPlace(
      displayName: 'Kyiv, Ukraine',
      country: 'Ukraine',
      latitude: 50.4501,
      longitude: 30.5234,
    ),
    GeoPlace(
      displayName: 'London, United Kingdom',
      country: 'United Kingdom',
      latitude: 51.5074,
      longitude: -0.1278,
    ),
    GeoPlace(
      displayName: 'New York, United States',
      country: 'United States',
      latitude: 40.7128,
      longitude: -74.006,
      region: 'NY',
    ),
    GeoPlace(
      displayName: 'Los Angeles, United States',
      country: 'United States',
      latitude: 34.0522,
      longitude: -118.2437,
      region: 'CA',
    ),
    GeoPlace(
      displayName: 'Berlin, Germany',
      country: 'Germany',
      latitude: 52.52,
      longitude: 13.405,
    ),
    GeoPlace(
      displayName: 'Paris, France',
      country: 'France',
      latitude: 48.8566,
      longitude: 2.3522,
    ),
    GeoPlace(
      displayName: 'Tokyo, Japan',
      country: 'Japan',
      latitude: 35.6762,
      longitude: 139.6503,
    ),
    GeoPlace(
      displayName: 'Mumbai, India',
      country: 'India',
      latitude: 19.076,
      longitude: 72.8777,
    ),
    GeoPlace(
      displayName: 'Sao Paulo, Brazil',
      country: 'Brazil',
      latitude: -23.5505,
      longitude: -46.6333,
    ),
    GeoPlace(
      displayName: 'Sydney, Australia',
      country: 'Australia',
      latitude: -33.8688,
      longitude: 151.2093,
    ),
    GeoPlace(
      displayName: 'Toronto, Canada',
      country: 'Canada',
      latitude: 43.6532,
      longitude: -79.3832,
    ),
    GeoPlace(
      displayName: 'Mexico City, Mexico',
      country: 'Mexico',
      latitude: 19.4326,
      longitude: -99.1332,
    ),
  ];

  @override
  Future<List<GeoPlace>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const <GeoPlace>[];
    final needle = trimmed.toLowerCase();
    return _places
        .where((place) => place.displayName.toLowerCase().contains(needle))
        .take(5)
        .toList(growable: false);
  }
}

/// Riverpod handle for the geocoder. Override in tests with
/// `ProviderScope(overrides: [...])` against
/// [geocodingServiceProvider].
final geocodingServiceProvider = Provider<GeocodingService>(
  (ref) => const StubGeocodingService(),
);
