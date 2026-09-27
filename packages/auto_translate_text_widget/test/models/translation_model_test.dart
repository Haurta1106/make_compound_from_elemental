import 'package:flutter_test/flutter_test.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() {
  group('TranslationModel', () {
    test('creates from constructor', () {
      const model = TranslationModel(
        sourceText: 'Hello',
        translatedText: 'হ্যালো',
        sourceLanguage: 'en',
        targetLanguage: 'bn',
      );
      expect(model.sourceText, 'Hello');
      expect(model.translatedText, 'হ্যালো');
      expect(model.sourceLanguage, 'en');
      expect(model.targetLanguage, 'bn');
    });

    test('serializes to JSON', () {
      const model = TranslationModel(
        sourceText: 'Hello',
        translatedText: 'Hola',
        sourceLanguage: 'en',
        targetLanguage: 'es',
      );
      final json = model.toJson();
      expect(json['sourceText'], 'Hello');
      expect(json['translatedText'], 'Hola');
      expect(json['sourceLanguage'], 'en');
      expect(json['targetLanguage'], 'es');
    });

    test('deserializes from JSON', () {
      final json = <String, dynamic>{
        'sourceText': 'Hello',
        'translatedText': 'Bonjour',
        'sourceLanguage': 'en',
        'targetLanguage': 'fr',
      };
      final model = TranslationModel.fromJson(json);
      expect(model.sourceText, 'Hello');
      expect(model.translatedText, 'Bonjour');
      expect(model.targetLanguage, 'fr');
    });

    test('equality works correctly', () {
      const a = TranslationModel(
        sourceText: 'Hello',
        translatedText: 'Hola',
        sourceLanguage: 'en',
        targetLanguage: 'es',
      );
      const b = TranslationModel(
        sourceText: 'Hello',
        translatedText: 'Hola',
        sourceLanguage: 'en',
        targetLanguage: 'es',
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString returns readable format', () {
      const model = TranslationModel(
        sourceText: 'Hi',
        translatedText: 'Hola',
        sourceLanguage: 'en',
        targetLanguage: 'es',
      );
      expect(model.toString(), contains('Hi'));
      expect(model.toString(), contains('Hola'));
    });
  });
}
