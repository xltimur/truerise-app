import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/prefs/result_feedback_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('ResultFeedbackAnswer', () {
    test('uses stable wire tags', () {
      expect(ResultFeedbackAnswer.yes.tag, 'yes');
      expect(ResultFeedbackAnswer.notSure.tag, 'not_sure');
      expect(ResultFeedbackAnswer.no.tag, 'no');
    });
  });

  group('ResultFeedbackStore', () {
    test('read returns null when no answer was recorded', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ResultFeedbackStore(prefs);

      expect(store.read('calc-1'), isNull);
    });

    test('write persists the answer for the given result id', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ResultFeedbackStore(prefs);

      await store.write('calc-1', ResultFeedbackAnswer.notSure);

      expect(store.read('calc-1'), ResultFeedbackAnswer.notSure);
    });

    test('write overwrites a previous answer', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ResultFeedbackStore(prefs);
      await store.write('calc-1', ResultFeedbackAnswer.yes);

      await store.write('calc-1', ResultFeedbackAnswer.no);

      expect(store.read('calc-1'), ResultFeedbackAnswer.no);
    });

    test('answers are stored per result id', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ResultFeedbackStore(prefs);

      await store.write('calc-1', ResultFeedbackAnswer.yes);
      await store.write('calc-2', ResultFeedbackAnswer.no);

      expect(store.read('calc-1'), ResultFeedbackAnswer.yes);
      expect(store.read('calc-2'), ResultFeedbackAnswer.no);
    });

    test('read returns null for an unknown stored tag', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'result_feedback.answer.calc-1': 'maybe',
      });
      final prefs = await SharedPreferences.getInstance();
      final store = ResultFeedbackStore(prefs);

      expect(store.read('calc-1'), isNull);
    });

    test('clear removes only the given result id', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ResultFeedbackStore(prefs);
      await store.write('calc-1', ResultFeedbackAnswer.yes);
      await store.write('calc-2', ResultFeedbackAnswer.notSure);

      await store.clear('calc-1');

      expect(store.read('calc-1'), isNull);
      expect(store.read('calc-2'), ResultFeedbackAnswer.notSure);
    });

    test('write uses the result_feedback.answer key namespace', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ResultFeedbackStore(prefs);

      await store.write('calc-1', ResultFeedbackAnswer.notSure);

      expect(prefs.getString('result_feedback.answer.calc-1'), 'not_sure');
    });

    test('deleteAll removes every feedback key and nothing else', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'settings.time_format': '24h',
        'share.demo_prompt_seen': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final store = ResultFeedbackStore(prefs);
      await store.write('calc-1', ResultFeedbackAnswer.yes);
      await store.write('calc-2', ResultFeedbackAnswer.no);

      await store.deleteAll();

      expect(store.read('calc-1'), isNull);
      expect(store.read('calc-2'), isNull);
      expect(prefs.getString('settings.time_format'), '24h');
      expect(prefs.getBool('share.demo_prompt_seen'), isTrue);
    });
  });
}
