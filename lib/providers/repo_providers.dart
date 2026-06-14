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
///
/// No provider key means the API layer is already wired for proxy mode
/// (`dioProvider` / `rectificationApiProvider` target the proxy with no
/// Authorization header), so the repository submits regardless — never
/// a missing-key failure.
///
/// The local free-attempt quota applies to proxy mode and to the bundled
/// `.env` / env key; only a Settings-entered key
/// ([storedProApiKeyProvider]) bypasses it. While the secure-storage
/// read is loading (or errored) we treat it as "no user key yet" and
/// keep the quota enforced.
final rectificationRepositoryProvider = Provider<RectificationRepository>((
  ref,
) {
  final storedKey = ref.watch(storedProApiKeyProvider);
  final hasUserKey = storedKey.maybeWhen(
    data: (value) => value != null && value.isNotEmpty,
    orElse: () => false,
  );
  return LiveRectificationRepository(
    api: ref.watch(rectificationApiProvider),
    history: ref.watch(historyRepositoryProvider),
    liveQuotaStore: ref.watch(liveQuotaStoreProvider),
    bypassLiveQuota: hasUserKey,
  );
});

/// Combined settings repository (prefs + secure store + db wipe).
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => DefaultSettingsRepository(
    prefs: ref.watch(settingsStoreProvider),
    secure: ref.watch(secureKeyStoreProvider),
    db: ref.watch(appDatabaseProvider),
    resultFeedback: ref.watch(resultFeedbackStoreProvider),
  ),
);

/// In-memory draft repository. Released on app shutdown.
final draftRepositoryProvider = Provider<DraftRepository>((ref) {
  final repo = InMemoryDraftRepository();
  ref.onDispose(repo.dispose);
  return repo;
});
