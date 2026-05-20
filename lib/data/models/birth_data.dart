import 'package:freezed_annotation/freezed_annotation.dart';

part 'birth_data.freezed.dart';

/// User-supplied birth data carried by every calculation request
/// (`docs/implementation-plan.md` §7.1).
@freezed
abstract class BirthData with _$BirthData {
  const factory BirthData({
    required DateTime birthDate,
    required String birthCity,
    required double birthLatitude,
    required double birthLongitude,
    String? label,
  }) = _BirthData;
}
