import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/analytics/app_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('LocalAppAnalytics', () {
    test('records aggregate share counters without payload data', () async {
      final prefs = await SharedPreferences.getInstance();
      final analytics = LocalAppAnalytics(prefs);

      await analytics.recordShare(
        surface: ShareAnalyticsSurface.homeInvite,
        content: ShareAnalyticsContent.inviteText,
        outcome: ShareAnalyticsOutcome.nativeSheet,
      );
      await analytics.recordShare(
        surface: ShareAnalyticsSurface.homeInvite,
        content: ShareAnalyticsContent.inviteText,
        outcome: ShareAnalyticsOutcome.fallback,
      );

      expect(analytics.shareCount(), 2);
      expect(
        analytics.shareCount(surface: ShareAnalyticsSurface.homeInvite),
        2,
      );
      expect(
        analytics.shareCount(content: ShareAnalyticsContent.inviteText),
        2,
      );
      expect(
        analytics.shareCount(outcome: ShareAnalyticsOutcome.nativeSheet),
        1,
      );
      expect(analytics.shareCount(outcome: ShareAnalyticsOutcome.fallback), 1);

      final persisted = prefs.getKeys().join('\n');
      expect(persisted, isNot(contains('Kyiv')));
      expect(persisted, isNot(contains('Ukraine')));
      expect(persisted, isNot(contains('1990')));
      expect(persisted, isNot(contains('marriage')));
      expect(persisted, isNot(contains('req-001')));
    });

    test('deleteAll removes only analytics counters', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'settings.onboarding_done': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final analytics = LocalAppAnalytics(prefs);
      await analytics.recordShare(
        surface: ShareAnalyticsSurface.resultText,
        content: ShareAnalyticsContent.resultText,
        outcome: ShareAnalyticsOutcome.nativeSheet,
      );

      await analytics.deleteAll();

      expect(analytics.shareCount(), 0);
      expect(prefs.getBool('settings.onboarding_done'), isTrue);
    });
  });
}
