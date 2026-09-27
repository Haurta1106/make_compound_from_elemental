import 'package:flutter/material.dart';
import 'package:auto_translate_text_widget/auto_translate_text_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Translate Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedLanguage = 'en';

  static const _languages = <String, String>{
    'en': 'English',
    'bn': 'Bengali',
    'es': 'Spanish',
    'fr': 'French',
    'ar': 'Arabic',
    'hi': 'Hindi',
    'ja': 'Japanese',
    'zh-cn': 'Chinese',
    'de': 'German',
    'ko': 'Korean',
  };

  Future<void> _onLanguageChanged(String? code) async {
    if (code == null) return;
    setState(() => _selectedLanguage = code);
    await LanguageService.setLanguage(code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Translate Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              dropdownColor: theme.colorScheme.surface,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.language),
              items: _languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: _onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Basic Text
            const _SectionTitle(title: '1. AutoTranslateText'),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Welcome to our application',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    AutoTranslateText(
                      'This text is automatically translated at runtime.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: AutoSizeText
            const _SectionTitle(title: '2. AutoTranslateAutoSizeText'),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: AutoTranslateAutoSizeText(
                    'This is a very long text that will automatically resize to fit within its container bounds.',
                    maxLines: 2,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section 3: Typewriter
            const _SectionTitle(title: '3. AutoTranslateTypewriterText'),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 40,
                  child: AutoTranslateTypewriterText(
                    'Welcome to Flutter',
                    speed: Duration(milliseconds: 60),
                    style: TextStyle(fontSize: 20),
                    repeatForever: true,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section 4: RichText
            const _SectionTitle(title: '4. AutoTranslateRichText'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AutoTranslateRichText(
                  spans: [
                    TranslateSpan(
                      text: 'Hello ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    TranslateSpan(
                      text: 'World! ',
                      style: TextStyle(
                        fontSize: 20,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    TranslateSpan(
                      text: 'Flutter is amazing.',
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section 5: Shimmer Loading
            const _SectionTitle(title: '5. Shimmer Loading'),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: AutoTranslateText(
                  'This text shows a shimmer effect while loading.',
                  enableShimmer: true,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
