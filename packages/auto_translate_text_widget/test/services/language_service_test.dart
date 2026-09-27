import 'package:flutter_test/flutter_test.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() {
  setUp(() {
    LanguageService.reset();
  });

  group('LanguageService', () {
    test('default language is en', () {
      expect(LanguageService.language.value, 'en');
    });

    test('setLanguage updates the ValueNotifier', () async {
      await LanguageService.setLanguage('bn');
      expect(LanguageService.language.value, 'bn');
    });

    test('setLanguage notifies listeners', () async {
      String? notifiedValue;
      LanguageService.language.addListener(() {
        notifiedValue = LanguageService.language.value;
      });
      await LanguageService.setLanguage('es');
      expect(notifiedValue, 'es');
    });

    test('reset restores default language', () async {
      await LanguageService.setLanguage('fr');
      LanguageService.reset();
      expect(LanguageService.language.value, 'en');
    });
  });
}
