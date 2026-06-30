import 'package:rectify/core/analytics/app_analytics.dart';

class FakeAppAnalytics implements AppAnalytics {
  final List<
    ({
      ShareAnalyticsSurface surface,
      ShareAnalyticsContent content,
      ShareAnalyticsOutcome outcome,
    })
  >
  shareEvents = [];

  @override
  Future<void> recordShare({
    required ShareAnalyticsSurface surface,
    required ShareAnalyticsContent content,
    required ShareAnalyticsOutcome outcome,
  }) async {
    shareEvents.add((surface: surface, content: content, outcome: outcome));
  }

  @override
  Future<void> deleteAll() async {
    shareEvents.clear();
  }
}
