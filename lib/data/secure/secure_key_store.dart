import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

/// Exclusive storage location for the **end-user-supplied**
/// Pro / Developer API key (`docs/implementation-plan.md` §9.5).
///
/// The provider's shared API key is **never** here — that key lives
/// only on the proxy. Per §9.5 the key never travels through SQLite,
/// shared_preferences, logs, or analytics; this contract guarantees
/// at the type level by exposing only the read / write / clear
/// surface for a single `pro_api_key` slot.
abstract class SecureKeyStore {
  /// Production-flavoured store backed by `flutter_secure_storage`.
  factory SecureKeyStore() = _FlutterSecureKeyStore;

  /// Returns the stored key, or `null` if none has been set.
  Future<String?> readProApiKey();

  /// Persist (or overwrite) the user-supplied key. The caller is
  /// responsible for not echoing the key back into the UI in
  /// plaintext after this returns (§9.5 hard rule).
  Future<void> writeProApiKey(String value);

  /// Wipe the stored key. Idempotent.
  Future<void> clearProApiKey();

  /// Wipe every entry. Used by "Delete all data" (§8.5).
  Future<void> deleteAll();

  /// `true` when a key is currently stored. UI uses this to render
  /// a "Set" indicator without ever surfacing the key value.
  Future<bool> hasProApiKey();
}

class _FlutterSecureKeyStore implements SecureKeyStore {
  _FlutterSecureKeyStore({FlutterSecureStorage? backend})
    : _backend = backend ?? const FlutterSecureStorage();

  static const _key = 'pro_api_key';

  final FlutterSecureStorage _backend;

  @override
  Future<String?> readProApiKey() => _backend.read(key: _key);

  @override
  Future<void> writeProApiKey(String value) =>
      _backend.write(key: _key, value: value);

  @override
  Future<void> clearProApiKey() => _backend.delete(key: _key);

  @override
  Future<void> deleteAll() => _backend.deleteAll();

  @override
  Future<bool> hasProApiKey() async {
    final value = await readProApiKey();
    return value != null && value.isNotEmpty;
  }
}

/// In-memory implementation used by tests and the demo flow harness.
/// Identical surface; nothing touches the platform keychain.
@visibleForTesting
class InMemorySecureKeyStore implements SecureKeyStore {
  InMemorySecureKeyStore({String? seed}) : _value = seed;

  String? _value;

  @override
  Future<String?> readProApiKey() async => _value;

  @override
  Future<void> writeProApiKey(String value) async {
    _value = value;
  }

  @override
  Future<void> clearProApiKey() async {
    _value = null;
  }

  @override
  Future<void> deleteAll() async {
    _value = null;
  }

  @override
  Future<bool> hasProApiKey() async => _value != null && _value!.isNotEmpty;
}
