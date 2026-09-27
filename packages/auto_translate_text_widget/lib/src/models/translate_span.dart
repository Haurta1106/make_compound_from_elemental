import 'package:flutter/widgets.dart';

/// A text span with an associated style, used by [AutoTranslateRichText].
///
/// Each [TranslateSpan] is translated independently while preserving
/// its [TextStyle] properties (color, fontWeight, fontSize, etc.).
///
/// ```dart
/// TranslateSpan(
///   text: 'Hello ',
///   style: TextStyle(fontWeight: FontWeight.bold),
/// )
/// ```
class TranslateSpan {
  /// Creates a [TranslateSpan] with the given [text] and optional [style].
  const TranslateSpan({
    required this.text,
    this.style,
  });

  /// The text content to translate.
  final String text;

  /// The style applied to this span after translation.
  ///
  /// If `null`, the default text style is used.
  final TextStyle? style;

  @override
  String toString() => 'TranslateSpan(text: "$text", style: $style)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateSpan &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          style == other.style;

  @override
  int get hashCode => Object.hash(text, style);
}
