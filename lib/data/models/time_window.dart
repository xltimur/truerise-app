import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rectify/data/models/time_window_mode.dart';

part 'time_window.freezed.dart';

/// Birth-time window the rectifier searches across
/// (`docs/implementation-plan.md` §7.1).
///
/// `approximate` mode pairs an estimated time with a ± window (minutes).
/// `unknown` mode means the rectifier should consider the full 24h.
@freezed
abstract class TimeWindow with _$TimeWindow {
  const factory TimeWindow({
    required TimeWindowMode mode,
    @TimeOfDayConverter() TimeOfDay? approximateTime,
    int? windowMinutes,
  }) = _TimeWindow;

  const TimeWindow._();

  /// Convenience factory for the "unknown" mode.
  factory TimeWindow.unknown() =>
      const TimeWindow(mode: TimeWindowMode.unknown);

  /// Convenience factory for an approximate time with ± window minutes.
  factory TimeWindow.approximate({
    required TimeOfDay time,
    required int windowMinutes,
  }) => TimeWindow(
    mode: TimeWindowMode.approximate,
    approximateTime: time,
    windowMinutes: windowMinutes,
  );

  /// Resolved start of the search window as `(hour, minute)` in 24h.
  ///
  /// For [TimeWindowMode.unknown] returns `(0, 0)`.
  (int hour, int minute) get start {
    if (mode == TimeWindowMode.unknown ||
        approximateTime == null ||
        windowMinutes == null) {
      return (0, 0);
    }
    final base = approximateTime!.hour * 60 + approximateTime!.minute;
    final clamped = (base - windowMinutes!).clamp(0, 24 * 60 - 1);
    return (clamped ~/ 60, clamped % 60);
  }

  /// Resolved end of the search window as `(hour, minute)` in 24h.
  ///
  /// For [TimeWindowMode.unknown] returns `(23, 59)`.
  (int hour, int minute) get end {
    if (mode == TimeWindowMode.unknown ||
        approximateTime == null ||
        windowMinutes == null) {
      return (23, 59);
    }
    final base = approximateTime!.hour * 60 + approximateTime!.minute;
    final clamped = (base + windowMinutes!).clamp(0, 24 * 60 - 1);
    return (clamped ~/ 60, clamped % 60);
  }
}

/// Hand-written JsonConverter for [TimeOfDay] — freezed/json_serializable
/// only ships if a converter is provided.
class TimeOfDayConverter implements JsonConverter<TimeOfDay?, String?> {
  const TimeOfDayConverter();

  @override
  TimeOfDay? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    final parts = json.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  String? toJson(TimeOfDay? object) => object == null
      ? null
      : '${object.hour.toString().padLeft(2, '0')}:'
            '${object.minute.toString().padLeft(2, '0')}';
}
