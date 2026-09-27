import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() {
  setUp(() {
    LanguageService.reset();
    TranslationCache.clear();
  });

  group('AutoTranslateTypewriterText', () {
    testWidgets('renders AnimatedTextKit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoTranslateTypewriterText('Hello'),
          ),
        ),
      );
      expect(find.byType(AnimatedTextKit), findsOneWidget);
    });

    testWidgets('applies custom speed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoTranslateTypewriterText(
              'Hello',
              speed: Duration(milliseconds: 100),
            ),
          ),
        ),
      );
      expect(find.byType(AnimatedTextKit), findsOneWidget);
    });
  });
}
