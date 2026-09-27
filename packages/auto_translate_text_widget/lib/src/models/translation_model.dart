/// Represents a completed translation.
///
/// Holds the original text, translated text, and language metadata.
class TranslationModel {
  /// Creates a [TranslationModel].
  const TranslationModel({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  /// The original text before translation.
  final String sourceText;

  /// The translated text.
  final String translatedText;

  /// The language code of the source text (e.g., `'en'`).
  final String sourceLanguage;

  /// The language code of the translated text (e.g., `'bn'`).
  final String targetLanguage;

  /// Creates a [TranslationModel] from a JSON map.
  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      sourceText: json['sourceText'] as String? ?? '',
      translatedText: json['translatedText'] as String? ?? '',
      sourceLanguage: json['sourceLanguage'] as String? ?? '',
      targetLanguage: json['targetLanguage'] as String? ?? '',
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sourceText': sourceText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
    };
  }

  @override
  String toString() =>
      'TranslationModel(source: "$sourceText", translated: "$translatedText", '
      'from: $sourceLanguage, to: $targetLanguage)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationModel &&
          runtimeType == other.runtimeType &&
          sourceText == other.sourceText &&
          translatedText == other.translatedText &&
          sourceLanguage == other.sourceLanguage &&
          targetLanguage == other.targetLanguage;

  @override
  int get hashCode => Object.hash(
        sourceText,
        translatedText,
        sourceLanguage,
        targetLanguage,
      );
}
