import 'package:flutter_test/flutter_test.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() {
  setUp(() {
    TranslationCache.clear();
    LanguageService.reset();
  });

  group('AutoTranslate', () {
    test('returns cached translation when available', () async {
      TranslationCache.set('es', 'Hello', 'Hola');
      final result = await AutoTranslate.translateText('Hello', to: 'es');
      expect(result, 'Hola');
    });

    test('translate returns TranslationModel', () async {
      TranslationCache.set('bn', 'Hello', 'হ্যালো');
      final model = await AutoTranslate.translate('Hello', to: 'bn');
      expect(model.sourceText, 'Hello');
      expect(model.translatedText, 'হ্যালো');
      expect(model.targetLanguage, 'bn');
    });

    test('uses LanguageService.language when to is not specified', () async {
      LanguageService.language.value = 'fr';
      TranslationCache.set('fr', 'Hello', 'Bonjour');
      final result = await AutoTranslate.translateText('Hello');
      expect(result, 'Bonjour');
    });
  });
}
