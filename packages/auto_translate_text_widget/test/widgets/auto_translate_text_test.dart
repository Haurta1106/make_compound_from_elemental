import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() {
  setUp(() {
    LanguageService.reset();
    TranslationCache.clear();
  });

  group('AutoTranslateText', () {
    testWidgets('renders original text when language is en', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoTranslateText('Hello World'),
          ),
        ),
      );
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('applies text style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoTranslateText(
              'Hello',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
      final textWidget = tester.widget<Text>(find.text('Hello'));
      expect(textWidget.style?.fontSize, 24);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('shows translated text from cache', (tester) async {
      TranslationCache.set('bn', 'Hello', 'হ্যালো');
      LanguageService.language.value = 'bn';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoTranslateText('Hello'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('হ্যালো'), findsOneWidget);
    });

    testWidgets('respects maxLines parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoTranslateText(
              'Hello',
              maxLines: 2,
            ),
          ),
        ),
      );
      final textWidget = tester.widget<Text>(find.text('Hello'));
      expect(textWidget.maxLines, 2);
    });
  });
}
