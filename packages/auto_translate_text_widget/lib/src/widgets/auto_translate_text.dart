import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/auto_translate.dart';
import '../services/language_service.dart';

/// A [Text] widget that automatically translates its content.
///
/// Listens to [LanguageService.language] and rebuilds with the
/// translated text whenever the language changes. Shows the original
/// text while the translation is loading.
///
/// ```dart
/// AutoTranslateText(
///   'Welcome to our application',
///   style: TextStyle(fontSize: 18),
/// )
/// ```
///
/// Enable shimmer loading:
/// ```dart
/// AutoTranslateText(
///   'Hello',
///   enableShimmer: true,
/// )
/// ```
class AutoTranslateText extends StatelessWidget {
  /// Creates an [AutoTranslateText] widget.
  ///
  /// The [text] parameter is the source text to translate.
  const AutoTranslateText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.enableShimmer = false,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  /// The source text to translate.
  final String text;

  /// The text style to apply.
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// An optional maximum number of lines for the text to span.
  final int? maxLines;

  /// An alternative semantics label for this text.
  final String? semanticsLabel;

  /// Used to select a font based on the locale.
  final Locale? locale;

  /// The strut style to use.
  final StrutStyle? strutStyle;

  /// Defines how to measure the width of the rendered text.
  final TextWidthBasis? textWidthBasis;

  /// Defines how the paragraph will apply [TextStyle.height].
  final TextHeightBehavior? textHeightBehavior;

  /// The color to use when painting the selection.
  final Color? selectionColor;

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
                // If the language is English (default source), show original text
        if (language == 'ja') {
          return Text(
            text,
            style: style,
            textAlign: textAlign,
            textDirection: textDirection,
            softWrap: softWrap,
            overflow: overflow,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            locale: locale,
            strutStyle: strutStyle,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            selectionColor: selectionColor,
          );
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
                  child: Text(
                    text,
                    style: style,
                    textAlign: textAlign,
                    textDirection: textDirection,
                    softWrap: softWrap,
                    overflow: overflow,
                    maxLines: maxLines,
                  ),
                );
              }
              return Text(
                text,
                style: style,
                textAlign: textAlign,
                textDirection: textDirection,
                softWrap: softWrap,
                overflow: overflow,
                maxLines: maxLines,
                semanticsLabel: semanticsLabel,
                locale: locale,
                strutStyle: strutStyle,
                textWidthBasis: textWidthBasis,
                textHeightBehavior: textHeightBehavior,
                selectionColor: selectionColor,
              );
            }

            final translatedText = snapshot.data ?? text;

            return Text(
              translatedText,
              style: style,
              textAlign: textAlign,
              textDirection: textDirection,
              softWrap: softWrap,
              overflow: overflow,
              maxLines: maxLines,
              semanticsLabel: semanticsLabel,
              locale: locale,
              strutStyle: strutStyle,
              textWidthBasis: textWidthBasis,
              textHeightBehavior: textHeightBehavior,
              selectionColor: selectionColor,
            );
          },
        );
      },
    );
  }
}
