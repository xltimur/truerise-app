import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/repos/history_repository.dart';
import 'package:rectify/data/repos/rectification_repository.dart';
import 'package:rectify/data/repos/settings_repository.dart';
import 'package:rectify/providers/core_providers.dart';

/// Drift-backed history repository.
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return DriftHistoryRepository(ref.watch(appDatabaseProvider));
});

/// Live rectification repository — short-circuits demo, delegates
/// real submissions to `RectificationApi`.
final rectificationRepositoryProvider = Provider<RectificationRepository>(
  (ref) => LiveRectificationRepository(
    api: ref.watch(rectificationApiProvider),
    history: ref.watch(historyRepositoryProvider),
  ),
);

/// Combined settings repository (prefs + secure store + db wipe).
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => DefaultSettingsRepository(
    prefs: ref.watch(settingsStoreProvider),
    secure: ref.watch(secureKeyStoreProvider),
    db: ref.watch(appDatabaseProvider),
  ),
);

/// In-memory draft repository. Released on app shutdown.
final draftRepositoryProvider = Provider<DraftRepository>((ref) {
  final repo = InMemoryDraftRepository();
  ref.onDispose(repo.dispose);
  return repo;
});
