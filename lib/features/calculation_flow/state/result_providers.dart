import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;

import 'package:rectify/core/result.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/providers/repo_providers.dart';

/// Result-screen lookup keyed by calculation id
/// (`docs/implementation-plan.md` §14 Phase 5).
///
/// Reads through `HistoryRepository.findById` — the same path used by
/// the history list — so a freshly-saved demo result and a saved
/// calculation tapped from history reach the same source of truth.
/// Returns `null` when the id isn't found; the screen renders an
/// empty / not-found state in that case.
final FutureProviderFamily<SavedCalculation?, String>
savedCalculationByIdProvider = FutureProvider.family<SavedCalculation?, String>(
  (ref, resultId) async {
    final repo = ref.watch(historyRepositoryProvider);
    final lookup = await repo.findById(resultId);
    return switch (lookup) {
      Ok(:final value) => value,
      Err() => null,
    };
  },
);
