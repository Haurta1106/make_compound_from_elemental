import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/auto_translate.dart';
import '../services/language_service.dart';

/// A typewriter-animated text widget that automatically translates its content.
///
/// Translates the text first, then plays the typewriter animation with the
/// translated result. Rebuilds when the language changes.
///
/// ```dart
/// AutoTranslateTypewriterText(
///   'Welcome to Flutter',
///   speed: Duration(milliseconds: 60),
///   style: TextStyle(fontSize: 24),
/// )
/// ```
class AutoTranslateTypewriterText extends StatelessWidget {
  /// Creates an [AutoTranslateTypewriterText] widget.
  const AutoTranslateTypewriterText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.speed = const Duration(milliseconds: 60),
    this.cursor = '_',
    this.totalRepeatCount = 1,
    this.repeatForever = false,
    this.pause = const Duration(milliseconds: 1000),
    this.displayFullTextOnTap = true,
    this.stopPauseOnTap = true,
    this.onFinished,
    this.enableShimmer = false,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  /// The source text to translate and animate.
  final String text;

  /// The text style to apply.
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The typing speed per character.
  final Duration speed;

  /// The cursor character displayed during animation.
  final String cursor;

  /// Number of times the animation repeats.
  final int totalRepeatCount;

  /// Whether the animation repeats forever.
  final bool repeatForever;

  /// The pause duration between animation repeats.
  final Duration pause;

  /// Whether to show full text on tap.
  final bool displayFullTextOnTap;

  /// Whether to stop pause on tap.
  final bool stopPauseOnTap;

  /// Callback when the animation finishes.
  final VoidCallback? onFinished;

  /// Whether to show a shimmer effect while loading.
  final bool enableShimmer;

  /// The base color for the shimmer effect.
  final Color? shimmerBaseColor;

  /// The highlight color for the shimmer effect.
  final Color? shimmerHighlightColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.language,
      builder: (context, language, _) {
        if (language == 'en') {
          return _buildTypewriter(text);
        }

        return FutureBuilder<String>(
          future: AutoTranslate.translateText(text, to: language),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              if (enableShimmer) {
                return Shimmer.fromColors(
                  baseColor: shimmerBaseColor ?? Colors.grey.shade300,
                  highlightColor:
                      shimmerHighlightColor ?? Colors.grey.shade100,
                  child: Text(text, style: style),
                );
              }
              return Text(text, style: style);
            }

            final translatedText = snapshot.data ?? text;
            return _buildTypewriter(translatedText);
          },
        );
      },
    );
  }

  Widget _buildTypewriter(String displayText) {
    return AnimatedTextKit(
      key: ValueKey<String>(displayText),
      animatedTexts: [
        TypewriterAnimatedText(
          displayText,
          textStyle: style,
          textAlign: textAlign ?? TextAlign.start,
          speed: speed,
          cursor: cursor,
        ),
      ],
      totalRepeatCount: totalRepeatCount,
      repeatForever: repeatForever,
      pause: pause,
      displayFullTextOnTap: displayFullTextOnTap,
      stopPauseOnTap: stopPauseOnTap,
      onFinished: onFinished,
    );
  }
}
