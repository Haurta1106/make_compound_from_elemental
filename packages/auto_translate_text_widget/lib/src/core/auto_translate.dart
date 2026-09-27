import 'dart:async';

import 'package:translator/translator.dart';

import '../services/language_service.dart';
import '../services/translation_cache.dart';
import '../models/translation_model.dart';

/// A static helper for translating text.
///
/// Uses [GoogleTranslator] from the `translator` package, with
/// an in-memory [TranslationCache] to avoid redundant API calls
/// and a [Completer]-based mechanism to deduplicate concurrent
/// requests for the same text.
///
/// ```dart
/// final translated = await AutoTranslate.translateText(
///   'Hello World',
///   to: 'bn',
/// );
/// ```
class AutoTranslate {
  AutoTranslate._();

  static final GoogleTranslator _translator = GoogleTranslator();

  /// In-flight requests keyed by `"targetLanguage:sourceText"`.
  ///
  /// Prevents duplicate concurrent API calls for the same translation.
  static final Map<String, Completer<String>> _pending =
      <String, Completer<String>>{};

  /// Translates [text] to the specified language.
  ///
  /// * If [to] is omitted, the current [LanguageService.language] is used.
  /// * If [from] is omitted, the source language is auto-detected.
  /// * Returns the cached result when available.
  /// * Deduplicates concurrent calls for the same text + language.
  /// * Returns the original [text] on any error (never throws).
  static Future<String> translateText(
    String text, {
    String? from,
    String? to,
  }) async {
    final targetLanguage = to ?? LanguageService.language.value;

    // No translation needed for the source language
    if (from != null) {
      return text;
    }

    // Check cache first
    final cached = TranslationCache.get(targetLanguage, text);
    if (cached != null) {
      return cached;
    }

    // Deduplicate concurrent requests
    final pendingKey = '$targetLanguage:$text';
    if (_pending.containsKey(pendingKey)) {
      return _pending[pendingKey]!.future;
    }

    final completer = Completer<String>();
    _pending[pendingKey] = completer;

    try {
      final translation = await _translator.translate(
        text,
        from: from ?? 'auto',
        to: targetLanguage,
      );

      final result = translation.text;

      // Cache the result
      TranslationCache.set(targetLanguage, text, result);

      completer.complete(result);
      return result;
    } catch (_) {
      // On error, return original text — never crash the UI
      completer.complete(text);
      return text;
    } finally {
      _pending.remove(pendingKey);
    }
  }

  /// Translates [text] and returns a full [TranslationModel].
  ///
  /// Useful when you need metadata about the translation
  /// (source language, target language, etc.).
  static Future<TranslationModel> translate(
    String text, {
    String? from,
    String? to,
  }) async {
    final targetLanguage = to ?? LanguageService.language.value;
    final sourceLanguage = from ?? 'auto';
    final translatedText = await translateText(
      text,
      from: from,
      to: to,
    );

    return TranslationModel(
      sourceText: text,
      translatedText: translatedText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }
}
