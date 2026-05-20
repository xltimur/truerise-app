import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/data/repos/draft_repository.dart';

import '../fixtures/sample_calculation.dart';

void main() {
  group('InMemoryDraftRepository', () {
    test('starts empty', () async {
      final repo = InMemoryDraftRepository();
      expect(repo.read(), isNull);
      await repo.dispose();
    });

    test(
      'write replaces the draft and read returns the latest value',
      () async {
        final repo = InMemoryDraftRepository();
        final draft = sampleRequest();

        repo.write(draft);
        expect(repo.read(), draft);

        final updated = draft.copyWith(label: 'Updated');
        repo.write(updated);
        expect(repo.read()?.label, 'Updated');

        await repo.dispose();
      },
    );

    test('watch emits the current value then every subsequent write', () async {
      final repo = InMemoryDraftRepository();
      final emissions = <String?>[];
      final sub = repo.watch().listen((draft) => emissions.add(draft?.label));

      repo
        ..write(sampleRequest(id: 'a').copyWith(label: 'Draft A'))
        ..write(sampleRequest(id: 'b').copyWith(label: 'Draft B'))
        ..clear();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      await sub.cancel();
      expect(emissions, <String?>[null, 'Draft A', 'Draft B', null]);

      await repo.dispose();
    });
  });
}
