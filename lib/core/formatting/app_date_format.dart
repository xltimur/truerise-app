import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rectify/data/models/time_format.dart';

/// Locale-aware date and clock formatting (gap G21).
///
/// Replaces the hand-rolled AM/PM arithmetic and the three duplicated
/// `Jan..Dec` month maps that previously lived in the calc-flow screens. All
/// output is produced by `intl`'s [DateFormat], so month names, date order,
/// and the day-period marker follow the active locale.
///
/// `localeName` defaults to `intl`'s current locale. The app currently ships
/// English only, so the default resolves to English today; when target
/// locales are added, callers thread the active locale (or set
/// `Intl.defaultLocale`) and every format follows.
class AppDateFormat {
  const AppDateFormat._();

  static DateTime _timeAsDate(TimeOfDay time) =>
      DateTime(2000, 1, 1, time.hour, time.minute);

  /// A full clock time as one string: `7:14 AM` (12-hour) or `07:14`
  /// (24-hour).
  ///
  /// Built from [clockParts] joined with a regular space so the meridiem
  /// separator stays a plain ASCII space rather than the CLDR narrow
  /// no-break space `DateFormat.jm` emits — keeping the English sample
  /// strings (`7:14 AM`) byte-stable for the UI and existing tests.
  static String clockTime(
    TimeOfDay time,
    TimeFormat format, {
    String? localeName,
  }) {
    final parts = clockParts(time, format, localeName: localeName);
    if (parts.meridiem.isEmpty) return parts.time;
    return '${parts.time} ${parts.meridiem}';
  }

  /// A clock time split into its numeric part and a separate meridiem token,
  /// for widgets (hero/candidate cards) that style the two independently.
  /// 24-hour mode yields an empty meridiem.
  static ({String time, String meridiem}) clockParts(
    TimeOfDay time,
    TimeFormat format, {
    String? localeName,
  }) {
    final date = _timeAsDate(time);
    if (format == TimeFormat.h24) {
      return (time: DateFormat.Hm(localeName).format(date), meridiem: '');
    }
    return (
      time: DateFormat('h:mm', localeName).format(date),
      meridiem: DateFormat('a', localeName).format(date),
    );
  }

  /// A full date with the month spelled out, e.g. `June 2, 2026` (en).
  static String longDate(DateTime date, {String? localeName}) =>
      DateFormat.yMMMMd(localeName).format(date.toLocal());

  /// An abbreviated month with year, e.g. `Jun 2026` (en).
  static String monthYear(DateTime date, {String? localeName}) =>
      DateFormat.yMMM(localeName).format(date.toLocal());

  /// An abbreviated month with year from raw parts, e.g. `Jun 2026` (en).
  static String monthYearParts(int month, int year, {String? localeName}) =>
      DateFormat.yMMM(localeName).format(DateTime(year, month));

  /// An abbreviated month name, e.g. `Jan`..`Dec` (en). [month] is 1-12.
  static String monthAbbrev(int month, {String? localeName}) =>
      DateFormat.MMM(localeName).format(DateTime(2000, month));

  /// Event-date display: the bare year when [month] is null, otherwise the
  /// abbreviated month with year.
  static String optionalMonthYear(int? month, int year, {String? localeName}) =>
      month == null
      ? year.toString()
      : monthYearParts(month, year, localeName: localeName);
}
