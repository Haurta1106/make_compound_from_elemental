import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/auto_translate.dart';
import '../services/language_service.dart';

/// An [AutoSizeText] widget that automatically translates its content.
///
/// Combines the auto-sizing behavior of [AutoSizeText] with automatic
/// translation via [LanguageService]. The text resizes to fit within
/// its bounds after translation.
///
/// ```dart
/// AutoTranslateAutoSizeText(
///   'This is a very long text that needs to be translated',
///   maxLines: 2,
///   minFontSize: 12,
/// )
/// ```
class AutoTranslateAutoSizeText extends StatelessWidget {
  /// Creates an [AutoTranslateAutoSizeText] widget.
  const AutoTranslateAutoSizeText(
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
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.group,
    this.wrapWords = true,
    this.overflowReplacement,
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

  /// An alternative semantics label.
  final String? semanticsLabel;

  /// The locale for font selection.
  final Locale? locale;

  /// The strut style to use.
  final StrutStyle? strutStyle;

  /// Defines how to measure the width of the rendered text.
  final TextWidthBasis? textWidthBasis;

  /// The minimum text size constraint.
  final double minFontSize;

  /// The maximum text size constraint.
  final double maxFontSize;

  /// The step size for font size adaptation.
  final double stepGranularity;

  /// Predefined font sizes to use.
  final List<double>? presetFontSizes;

  /// Synchronizes the font size with other [AutoSizeText] widgets.
  final AutoSizeGroup? group;

  /// Whether words should be wrapped.
  final bool wrapWords;

  /// Widget displayed if the text overflows.
  final Widget? overflowReplacement;

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
          return AutoSizeText(
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
            minFontSize: minFontSize,
            maxFontSize: maxFontSize,
            stepGranularity: stepGranularity,
            presetFontSizes: presetFontSizes,
            group: group,
            wrapWords: wrapWords,
            overflowReplacement: overflowReplacement,
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
                  child: AutoSizeText(
                    text,
                    style: style,
                    maxLines: maxLines,
                    minFontSize: minFontSize,
                    maxFontSize: maxFontSize,
                  ),
                );
              }
              return AutoSizeText(
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
                minFontSize: minFontSize,
                maxFontSize: maxFontSize,
                stepGranularity: stepGranularity,
                presetFontSizes: presetFontSizes,
                group: group,
                wrapWords: wrapWords,
                overflowReplacement: overflowReplacement,
              );
            }

            final translatedText = snapshot.data ?? text;

            return AutoSizeText(
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
              minFontSize: minFontSize,
              maxFontSize: maxFontSize,
              stepGranularity: stepGranularity,
              presetFontSizes: presetFontSizes,
              group: group,
              wrapWords: wrapWords,
              overflowReplacement: overflowReplacement,
            );
          },
        );
      },
    );
  }
}
