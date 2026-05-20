import 'dart:async';

import 'package:rectify/data/models/calculation_request.dart';

/// Repository contract for the in-progress calculation draft
/// (`docs/implementation-plan.md` §8.3).
///
/// MVP ships an in-memory implementation; the persisted draft (used
/// by the "Save and retry later" error path) lands in Phase 7.
abstract class DraftRepository {
  /// Stream the current draft (`null` when none is in progress).
  Stream<CalculationRequest?> watch();

  /// Snapshot of the current draft.
  CalculationRequest? read();

  /// Replace the draft outright. Pass `null` to clear.
  void write(CalculationRequest? draft);

  /// Drop the draft. Convenience over `write(null)`.
  void clear();
}

/// In-memory draft repository. Drafts evaporate on app kill, which is
/// acceptable for the MVP must-have flow (§8.3).
class InMemoryDraftRepository implements DraftRepository {
  InMemoryDraftRepository();

  CalculationRequest? _draft;
  final _controller = StreamController<CalculationRequest?>.broadcast();

  @override
  Stream<CalculationRequest?> watch() {
    final controller = StreamController<CalculationRequest?>();
    StreamSubscription<CalculationRequest?>? subscription;
    controller
      ..onListen = () {
        controller.add(_draft);
        subscription = _controller.stream.listen(controller.add);
      }
      ..onCancel = () async {
        await subscription?.cancel();
      };
    return controller.stream;
  }

  @override
  CalculationRequest? read() => _draft;

  @override
  void write(CalculationRequest? draft) {
    _draft = draft;
    if (!_controller.isClosed) _controller.add(draft);
  }

  @override
  void clear() => write(null);

  /// Releases the underlying broadcast controller. Tests / shell
  /// teardown should call this; production providers stay alive for
  /// the app lifetime.
  Future<void> dispose() async {
    await _controller.close();
  }
}
