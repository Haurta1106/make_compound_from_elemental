import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/auto_translate.dart';
import '../models/translate_span.dart';
import '../services/language_service.dart';

/// A [RichText] widget that translates each span independently.
///
/// Preserves per-span [TextStyle] properties (color, fontWeight,
/// fontSize, etc.) while translating each span's text content.
///
/// ```dart
/// AutoTranslateRichText(
///   spans: [
///     TranslateSpan(
///       text: 'Hello ',
///       style: TextStyle(fontWeight: FontWeight.bold),
///     ),
///     TranslateSpan(
///       text: 'World',
///       style: TextStyle(color: Colors.blue),
///     ),
///   ],
/// )
/// ```
class AutoTranslateRichText extends StatelessWidget {
  /// Creates an [AutoTranslateRichText] widget.
  const AutoTranslateRichText({
    super.key,
    required this.spans,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.enableShimmer = false,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  /// The list of [TranslateSpan]s to translate and render.
  final List<TranslateSpan> spans;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// An optional maximum number of lines.
  final int? maxLines;

  /// The locale for font selection.
  final Locale? locale;

  /// The strut style to use.
  final StrutStyle? strutStyle;

  /// Defines how to measure the width of the rendered text.
  final TextWidthBasis textWidthBasis;

  /// Defines how the paragraph will apply [TextStyle.height].
  final TextHeightBehavior? textHeightBehavior;

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
          return _buildRichText(
            spans.map((s) => TextSpan(text: s.text, style: s.style)).toList(),
          );
        }

        return FutureBuilder<List<String>>(
          future: _translateAllSpans(language),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              final originalSpans = spans
                  .map((s) => TextSpan(text: s.text, style: s.style))
                  .toList();

              if (enableShimmer) {
                return Shimmer.fromColors(
                  baseColor: shimmerBaseColor ?? Colors.grey.shade300,
                  highlightColor:
                      shimmerHighlightColor ?? Colors.grey.shade100,
                  child: _buildRichText(originalSpans),
                );
              }
              return _buildRichText(originalSpans);
            }

            final translations = snapshot.data;
            final textSpans = <TextSpan>[];
            for (var i = 0; i < spans.length; i++) {
              textSpans.add(TextSpan(
                text: translations != null && i < translations.length
                    ? translations[i]
                    : spans[i].text,
                style: spans[i].style,
              ));
            }

            return _buildRichText(textSpans);
          },
        );
      },
    );
  }

  Future<List<String>> _translateAllSpans(String language) async {
    final futures = spans.map(
      (span) => AutoTranslate.translateText(span.text, to: language),
    );
    return Future.wait(futures);
  }

  Widget _buildRichText(List<TextSpan> textSpans) {
    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
