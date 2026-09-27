/// An in-memory cache for translated text.
///
/// Stores translations using a `"targetLanguage:sourceText"` key format
/// to avoid redundant API calls and speed up the UI.
///
/// ```dart
/// // Store a translation
/// TranslationCache.set('bn', 'Hello', 'হ্যালো');
///
/// // Retrieve it later
/// final cached = TranslationCache.get('bn', 'Hello'); // 'হ্যালো'
/// ```
class TranslationCache {
  TranslationCache._();

  static final Map<String, String> _cache = <String, String>{};

  /// Builds the cache key from a language code and source text.
  static String _key(String language, String text) => '$language:$text';

  /// Returns the cached translation, or `null` if not found.
  static String? get(String language, String text) {
    return _cache[_key(language, text)];
  }

  /// Stores a translation in the cache.
  static void set(String language, String text, String translation) {
    _cache[_key(language, text)] = translation;
  }

  /// Returns `true` if a translation exists in the cache.
  static bool contains(String language, String text) {
    return _cache.containsKey(_key(language, text));
  }

  /// Removes all cached translations.
  static void clear() {
    _cache.clear();
  }

  /// Removes all cached translations for a specific language.
  static void clearForLanguage(String language) {
    _cache.removeWhere((key, _) => key.startsWith('$language:'));
  }

  /// Returns the number of cached translations.
  static int get length => _cache.length;
}
