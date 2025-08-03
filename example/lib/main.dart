import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import your library using its package name!
import 'package:qaid_markdown_editor/qaid_markdown_editor.dart'; 

void main() {
  runApp(const MyApp());
}

// A simple ValueNotifier to manage the app's theme.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Qaid Markdown Editor Example',
          themeMode: currentMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const EditorExamplePage(),
        );
      },
    );
  }
}

class EditorExamplePage extends StatefulWidget {
  const EditorExamplePage({super.key});

  @override
  State<EditorExamplePage> createState() => _EditorExamplePageState();
}

class _EditorExamplePageState extends State<EditorExamplePage> {
  // It's best practice to manage the controller in the stateful widget that uses the editor.
  final _controller = TextEditingController(text: '# Hello, Qaid!\n\nThis is your editor in action.');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    themeNotifier.value = themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void _saveDocument() {
    final content = _controller.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Document saved! It has ${content.length} characters.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Here is your library widget in action!
    return QaidMarkdownEditor(
      controller: _controller,
      title: Text(
        'My Document',
        style: GoogleFonts.dosis(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          onPressed: _toggleTheme,
          icon: Icon(
            themeNotifier.value == ThemeMode.light
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
          ),
          tooltip: 'Toggle Theme',
        ),
        IconButton(
          onPressed: _saveDocument,
          icon: const Icon(Icons.save_alt_outlined),
          tooltip: 'Save Document',
        ),
      ],
    );
  }
}