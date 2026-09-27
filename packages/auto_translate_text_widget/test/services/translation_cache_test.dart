import 'package:flutter_test/flutter_test.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() {
  setUp(() {
    TranslationCache.clear();
  });

  group('TranslationCache', () {
    test('returns null for uncached translation', () {
      expect(TranslationCache.get('bn', 'Hello'), isNull);
    });

    test('stores and retrieves a translation', () {
      TranslationCache.set('bn', 'Hello', 'হ্যালো');
      expect(TranslationCache.get('bn', 'Hello'), 'হ্যালো');
    });

    test('uses language:text key format', () {
      TranslationCache.set('es', 'Hello', 'Hola');
      TranslationCache.set('bn', 'Hello', 'হ্যালো');
      expect(TranslationCache.get('es', 'Hello'), 'Hola');
      expect(TranslationCache.get('bn', 'Hello'), 'হ্যালো');
    });

    test('contains returns true for cached entries', () {
      TranslationCache.set('fr', 'Hello', 'Bonjour');
      expect(TranslationCache.contains('fr', 'Hello'), isTrue);
      expect(TranslationCache.contains('de', 'Hello'), isFalse);
    });

    test('clear removes all entries', () {
      TranslationCache.set('es', 'Hello', 'Hola');
      TranslationCache.set('bn', 'Hello', 'হ্যালো');
      TranslationCache.clear();
      expect(TranslationCache.length, 0);
    });

    test('clearForLanguage removes only that language', () {
      TranslationCache.set('es', 'Hello', 'Hola');
      TranslationCache.set('bn', 'Hello', 'হ্যালো');
      TranslationCache.set('es', 'World', 'Mundo');
      TranslationCache.clearForLanguage('es');
      expect(TranslationCache.get('es', 'Hello'), isNull);
      expect(TranslationCache.get('es', 'World'), isNull);
      expect(TranslationCache.get('bn', 'Hello'), 'হ্যালো');
    });

    test('length returns correct count', () {
      expect(TranslationCache.length, 0);
      TranslationCache.set('es', 'Hello', 'Hola');
      expect(TranslationCache.length, 1);
      TranslationCache.set('bn', 'Hello', 'হ্যালো');
      expect(TranslationCache.length, 2);
    });
  });
}
