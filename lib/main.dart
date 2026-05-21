import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Demo-build .env is bundled as an asset (pubspec.yaml → flutter.assets)
  // so the reviewer's APK boots with a working ASTRO_API_KEY. The in-app
  // Settings → API Key override (flutter_secure_storage) still wins when
  // set — see proApiKeyProvider in core_providers.dart. Missing .env is
  // tolerated so unit tests and stripped builds still run.
  try {
    await dotenv.load();
  } on Object catch (error) {
    debugPrint('[rectify] .env not loaded: $error');
  }

  // SharedPreferences is read synchronously by the settings controller
  // and the router's onboarding gate, so resolve it before the first
  // frame and override the provider with the live instance.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const RectifyApp(),
    ),
  );
}
