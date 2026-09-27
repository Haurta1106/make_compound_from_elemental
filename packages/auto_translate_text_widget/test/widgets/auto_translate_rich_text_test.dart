import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() {
  setUp(() {
    LanguageService.reset();
    TranslationCache.clear();
  });

  group('AutoTranslateRichText', () {
    testWidgets('renders RichText with original spans', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoTranslateRichText(
              spans: [
                TranslateSpan(
                  text: 'Hello ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TranslateSpan(
                  text: 'World',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('shows translated spans from cache', (tester) async {
      TranslationCache.set('bn', 'Hello ', 'হ্যালো ');
      TranslationCache.set('bn', 'World', 'বিশ্ব');
      LanguageService.language.value = 'bn';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoTranslateRichText(
              spans: [
                TranslateSpan(text: 'Hello '),
                TranslateSpan(text: 'World'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RichText), findsOneWidget);
    });
  });
}
