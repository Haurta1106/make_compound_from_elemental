import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() {
  setUp(() {
    LanguageService.reset();
    TranslationCache.clear();
  });

  group('AutoTranslateAutoSizeText', () {
    testWidgets('renders AutoSizeText with original text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 100,
              child: AutoTranslateAutoSizeText(
                'Hello World',
                maxLines: 2,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(AutoSizeText), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('shows translated text from cache', (tester) async {
      TranslationCache.set('es', 'Hello', 'Hola');
      LanguageService.language.value = 'es';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 100,
              child: AutoTranslateAutoSizeText('Hello'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hola'), findsOneWidget);
    });
  });
}
