import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rectify/core/formatting/app_date_format.dart';
import 'package:rectify/data/models/time_format.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('AppDateFormat.clockTime', () {
    test('renders 12-hour times with a localized meridiem', () {
      expect(
        AppDateFormat.clockTime(
          const TimeOfDay(hour: 7, minute: 14),
          TimeFormat.h12,
          localeName: 'en',
        ),
        '7:14 AM',
      );
      expect(
        AppDateFormat.clockTime(
          const TimeOfDay(hour: 19, minute: 5),
          TimeFormat.h12,
          localeName: 'en',
        ),
        '7:05 PM',
      );
      expect(
        AppDateFormat.clockTime(
          const TimeOfDay(hour: 0, minute: 0),
          TimeFormat.h12,
          localeName: 'en',
        ),
        '12:00 AM',
      );
      expect(
        AppDateFormat.clockTime(
          const TimeOfDay(hour: 12, minute: 0),
          TimeFormat.h12,
          localeName: 'en',
        ),
        '12:00 PM',
      );
    });

    test('renders 24-hour times with a zero-padded hour and no meridiem', () {
      expect(
        AppDateFormat.clockTime(
          const TimeOfDay(hour: 7, minute: 14),
          TimeFormat.h24,
          localeName: 'en',
        ),
        '07:14',
      );
      expect(
        AppDateFormat.clockTime(
          const TimeOfDay(hour: 19, minute: 5),
          TimeFormat.h24,
          localeName: 'en',
        ),
        '19:05',
      );
    });
  });

  group('AppDateFormat.clockParts', () {
    test('splits the numeric time from the meridiem in 12-hour mode', () {
      final parts = AppDateFormat.clockParts(
        const TimeOfDay(hour: 7, minute: 14),
        TimeFormat.h12,
        localeName: 'en',
      );
      expect(parts.time, '7:14');
      expect(parts.meridiem, 'AM');
    });

    test('returns an empty meridiem in 24-hour mode', () {
      final parts = AppDateFormat.clockParts(
        const TimeOfDay(hour: 7, minute: 14),
        TimeFormat.h24,
        localeName: 'en',
      );
      expect(parts.time, '07:14');
      expect(parts.meridiem, '');
    });
  });

  group('AppDateFormat date helpers', () {
    test('longDate renders a full month name and locale order', () {
      expect(
        AppDateFormat.longDate(DateTime(2026, 6, 2), localeName: 'en'),
        'June 2, 2026',
      );
    });

    test('monthYearParts renders an abbreviated month with the year', () {
      expect(
        AppDateFormat.monthYearParts(6, 2026, localeName: 'en'),
        'Jun 2026',
      );
    });

    test('monthAbbrev renders abbreviated month names', () {
      expect(AppDateFormat.monthAbbrev(1, localeName: 'en'), 'Jan');
      expect(AppDateFormat.monthAbbrev(12, localeName: 'en'), 'Dec');
    });

    test('optionalMonthYear falls back to the year when month is null', () {
      expect(
        AppDateFormat.optionalMonthYear(null, 2026, localeName: 'en'),
        '2026',
      );
      expect(
        AppDateFormat.optionalMonthYear(6, 2026, localeName: 'en'),
        'Jun 2026',
      );
    });
  });
}
