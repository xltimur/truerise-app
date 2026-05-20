import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_place.freezed.dart';

/// One geocoding hit returned by the geocoding service
/// (`docs/implementation-plan.md` §7.1).
@freezed
abstract class GeoPlace with _$GeoPlace {
  const factory GeoPlace({
    required String displayName,
    required String country,
    required double latitude,
    required double longitude,
    String? region,
  }) = _GeoPlace;
}
