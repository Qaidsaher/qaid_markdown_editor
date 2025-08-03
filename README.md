# Qaid Markdown Editor

[![pub package](https://img.shields.io/pub/v/qaid_markdown_editor.svg)](https://pub.dev/packages/qaid_markdown_editor)

A professional, modern, and highly customizable Markdown editor widget for Flutter, featuring a live preview and syntax highlighting.

*Note: You should add a screenshot or GIF of your editor here!*

## Features

- 📱 **Responsive UI**: Split-view for wide screens, tab view for narrow screens.
- 🎨 **Syntax Highlighting**: Customizable themes for both light and dark modes.
- 🔧 **Highly Customizable**: Add custom action buttons, a title, and use your own `TextEditingController`.
- 📝 **Built-in Templates**: Quickly insert templates for tables, code blocks, and checklists.
- 🌐 **GFM Support**: Renders GitHub Flavored Markdown, including tables and task lists.

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  qaid_markdown_editor: ^1.0.0 # Use the latest version
```

Then, import the library and use the widget in your app:

```dart
import 'package:flutter/material.dart';
import 'package:qaid_markdown_editor/qaid_markdown_editor.dart';

class MyEditorPage extends StatelessWidget {
  const MyEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QaidMarkdownEditor(
        title: Text('My Document'),
        initialValue: '# Hello, World!',
      ),
    );
  }
}
```

## Customization Example

You can easily customize the editor by passing additional parameters.

```dart
class MyAdvancedEditorPage extends StatefulWidget {
  const MyAdvancedEditorPage({super.key});
  @override
  State<MyAdvancedEditorPage> createState() => _MyAdvancedEditorPageState();
}

class _MyAdvancedEditorPageState extends State<MyAdvancedEditorPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QaidMarkdownEditor(
      controller: _controller, // Use your own controller
      title: const Text('My Custom Editor'),
      actions: [ // Add custom buttons to the AppBar
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            final content = _controller.text;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Content saved! Length: ${content.length}')),
            );
          },
        ),
      ],
    );
  }
}
