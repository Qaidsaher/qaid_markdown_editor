import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qaid_markdown_editor/qaid_markdown_editor.dart';

const String _showcaseText = """
# ✨ Welcome to the Qaid Markdown Editor!

This editor is a powerful tool for writing beautiful documentation, created by **Saher Qaid**.

This document is a live showcase of its capabilities. Feel free to edit it!

---

## Key Features

| Feature             | Status      | Supported |
|:--------------------|:-----------:|:---------:|
| Tables              | Complete    |     ✅    |
| Syntax Highlighting | Complete    |     ✅    |
| Task Lists          | Complete    |     ✅    |
| ~~Strikethrough~~   | Complete    |     ✅    |

---

## Code Highlighting Example

You can write clean, readable code in many languages, like Dart:

```dart
// A simple Flutter widget
class WelcomeWidget extends StatelessWidget {
  final String name;

  const WelcomeWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello, \$name!',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
Use code with caution.
Dart
Planning & Organization
Good planning is half the work. Use checklists and lists to organize your thoughts.
Project Roadmap
Phase 1: Foundation
Create the core editor UI.
Implement the live preview panel.
Phase 2: Features
Add syntax highlighting.
Implement cloud save functionality.
Phase 3: Publishing
Write documentation.
Publish to pub.dev!
Enjoy using the editor!
""";
void main() {
  runApp(const MyApp());
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        const iconTheme = IconThemeData(size: 24.0, opacity: 0.9);
        return MaterialApp(
          title: 'Qaid Markdown Editor Example',
          themeMode: currentMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
            iconTheme: iconTheme,
            appBarTheme: const AppBarTheme(
              iconTheme: iconTheme,
              actionsIconTheme: iconTheme,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            iconTheme: iconTheme,
            appBarTheme: const AppBarTheme(
              iconTheme: iconTheme,
              actionsIconTheme: iconTheme,
            ),
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
  final _controller = TextEditingController(text: _showcaseText);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    themeNotifier.value =
        themeNotifier.value == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  void _saveDocument() {
    final content = _controller.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Document saved! It has ${content.length} characters.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        width: 400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return QaidMarkdownEditor(
      controller: _controller,
      title: Text(
        'Showcase Document',
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
