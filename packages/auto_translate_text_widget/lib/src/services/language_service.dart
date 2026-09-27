import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A global service for managing the current translation language.
///
/// Uses a [ValueNotifier] internally so all translation widgets
/// automatically rebuild when the language changes. The selected
/// language is persisted via [SharedPreferences].
///
/// ```dart
/// // Switch language — all widgets update instantly
/// await LanguageService.setLanguage('bn');
///
/// // Read current language
/// final lang = await LanguageService.getCurrentLanguage();
/// ```
class LanguageService {
  LanguageService._();

  static const String _prefsKey = 'auto_translate_language';

  /// A [ValueNotifier] that broadcasts the current language code.
  ///
  /// Translation widgets listen to this via [ValueListenableBuilder]
  /// and rebuild automatically when the value changes.
  static final ValueNotifier<String> language = ValueNotifier<String>('en');

  static bool _initialized = false;

  /// Initializes the service by loading the persisted language.
  ///
  /// Call this once at app startup (e.g., in `main()`) before
  /// using any translation widgets.
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await LanguageService.init();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> init() async {
  if (_initialized) return;
  _initialized = true;

  language.value = 'ja';
}

  /// Sets the current language and persists it.
  ///
  /// All translation widgets listening to [language] will
  /// rebuild automatically. No app restart or navigation
  /// refresh is required.
  ///
  /// [code] is a BCP-47 language code such as `'en'`, `'bn'`, `'es'`.
  static Future<void> setLanguage(String code) async {
    language.value = code;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, code);
    } catch (_) {
      // Persist failure is non-fatal
    }
  }

  /// Returns the current language code.
  ///
  /// Reads from [SharedPreferences] and falls back to the
  /// in-memory [language] value if persistence is unavailable.
  static Future<String> getCurrentLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_prefsKey) ?? language.value;
    } catch (_) {
      return language.value;
    }
  }

  /// Resets the service to its default state.
  ///
  /// Primarily useful for testing.
  @visibleForTesting
  static void reset() {
    language.value = 'en';
    _initialized = false;
  }
}
