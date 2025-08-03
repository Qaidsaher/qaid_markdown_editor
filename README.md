# Qaid Markdown Editor

[![pub package](https://img.shields.io/pub/v/qaid_markdown_editor.svg)](https://pub.dev/packages/qaid_markdown_editor)

A professional, modern, and highly customizable Markdown editor widget for Flutter, created by **Saher Qaid**.

![Qaid Markdown Editor Demo](https://raw.githubusercontent.com/QaidSaher/qaid_markdown_editor/main/screenshots/editor_demo.gif)
*(To add your own GIF, place it in a `screenshots` folder and update the link above)*

## Features

- 📱 **Responsive UI**: Split-view for wide screens, tab view for narrow screens.
- 🎨 **Syntax Highlighting**: Comes with beautiful, modern themes for both light and dark modes.
- 🔧 **Highly Customizable**: Add custom action buttons, a title, and use your own `TextEditingController`.
- 📝 **Built-in Templates**: Quickly insert templates for tables, code blocks, and checklists.
- 🌐 **GFM Support**: Renders GitHub Flavored Markdown, including tables and task lists.
- 📖 **Help Dialog**: A built-in guide to Markdown syntax for your users.

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  qaid_markdown_editor: ^1.0.0 # Use the latest version from pub.dev
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
        initialValue: '# Hello, from Qaid Markdown Editor!',
      ),
    );
  }
}
```

## Customization Example

You can easily customize the editor by passing additional parameters.

```dart
import 'package:flutter/material.dart';
import 'package:qaid_markdown_editor/qaid_markdown_editor.dart';
import 'package:google_fonts/google_fonts.dart';

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
      title: Text(
        'My Custom Editor',
        style: GoogleFonts.dosis(fontWeight: FontWeight.w600),
      ),
      actions: [ // Add your own custom buttons to the AppBar
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
```

## Widget Properties (API)

Here are the customizable properties of the `QaidMarkdownEditor` widget:

```dart
QaidMarkdownEditor({
  Key? key,
  TextEditingController? controller,
  String? initialValue,
  Widget? title,
  List<Widget>? actions,
  Map<String, TextStyle> lightCodeTheme,
  Map<String, TextStyle> darkCodeTheme,
})
```

| Parameter        | Type                       | Description                                                                                             |
|------------------|----------------------------|---------------------------------------------------------------------------------------------------------|
| `controller`     | `TextEditingController?`   | Manages the text. The widget creates its own if you don't provide one.                                  |
| `initialValue`   | `String?`                  | The initial text to display. Only used if a `controller` is not provided.                               |
| `title`          | `Widget?`                  | A widget to display in the `AppBar`'s title section.                                                    |
| `actions`        | `List<Widget>?`            | A list of extra widgets to display in the `AppBar` after the built-in help button.                      |
| `lightCodeTheme` | `Map<String, TextStyle>`   | The syntax highlighting theme for light mode. Defaults to `atomOneLightTheme`.                           |
| `darkCodeTheme`  | `Map<String, TextStyle>`   | The syntax highlighting theme for dark mode. Defaults to `atomOneDarkTheme`.                             |

## Issues and Contributions

If you find a bug or have a feature request, please file an issue on our [GitHub repository](https://github.com/QaidSaher/qaid_markdown_editor/issues). Contributions are also welcome!

---
*Package created and maintained by Saher Qaid.*