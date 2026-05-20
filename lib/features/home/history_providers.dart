import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/providers/repo_providers.dart';

/// Reactive history feed for the Home / History screen
/// (`docs/implementation-plan.md` §8.4).
///
/// Wraps `HistoryRepository.watchAll()` in a Riverpod `StreamProvider`
/// so the list re-renders on swipe-delete or new-result without manual
/// invalidation.
final historyStreamProvider = StreamProvider<List<SavedCalculation>>(
  (ref) => ref.watch(historyRepositoryProvider).watchAll(),
);
