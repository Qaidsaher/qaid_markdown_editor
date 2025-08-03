import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;

/// A professional, highly customizable Markdown editor widget for Flutter by Saher Qaid.
///
/// Features a live preview, syntax highlighting, and custom action buttons,
/// presented in a modern, professional UI.
class QaidMarkdownEditor extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final Widget? title;
  final List<Widget>? actions;
  final Map<String, TextStyle> lightCodeTheme;
  final Map<String, TextStyle> darkCodeTheme;

  const QaidMarkdownEditor({
    super.key,
    this.controller,
    this.initialValue,
    this.title,
    this.actions,
    this.lightCodeTheme = atomOneLightTheme,
    this.darkCodeTheme = atomOneDarkTheme,
  });

  @override
  State<QaidMarkdownEditor> createState() => _QaidMarkdownEditorState();
}

class _QaidMarkdownEditorState extends State<QaidMarkdownEditor>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _internalController;

  TextEditingController get _controller => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _insertText(String textToInsert) {
    final TextSelection selection = _controller.selection;

    if (!selection.isValid) {
      final newText = _controller.text + textToInsert;
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.fromPosition(TextPosition(offset: newText.length)),
      );
      return;
    }

    final newText = _controller.text.replaceRange(
      selection.start,
      selection.end,
      textToInsert,
    );
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: selection.start + textToInsert.length),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [Icon(Icons.help_outline_rounded), SizedBox(width: 8), Text('Markdown Guide')]),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
              child: MarkdownBody(
                  data: _qaidMarkdownGuide,
                  extensionSet: md.ExtensionSet.gitHubWeb)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        final isWideScreen = MediaQuery.of(context).size.width > 900;
        return Scaffold(
          appBar: AppBar(
            title: widget.title,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            actions: [
              IconButton(
                  icon: const Icon(Icons.help_outline),
                  tooltip: 'Markdown Guide',
                  onPressed: () => _showHelpDialog(context)),
              if (widget.actions != null) ...widget.actions!,
            ],
            bottom: isWideScreen
                ? null
                : TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Editor', icon: Icon(Icons.edit_document)),
                      Tab(text: 'Preview', icon: Icon(Icons.visibility)),
                    ],
                  ),
          ),
          body: isWideScreen
              ? _buildWideLayout(context)
              : _buildNarrowLayout(context),
        );
      },
    );
  }

  Widget _buildWideLayout(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
          child: _buildEditorPanel(context),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          child: _buildPreviewPanel(context),
        ),
      ),
    ],
  );

  Widget _buildNarrowLayout(BuildContext context) => TabBarView(
        controller: _tabController,
        children: [_buildEditorPanel(context), _buildPreviewPanel(context)],
      );

  Widget _buildEditorPanel(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildPanelHeader(context, "EDITOR", [
            PopupMenuButton<String>(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              tooltip: 'Insert Template',
              onSelected: _insertText,
              itemBuilder: (context) => const [
                PopupMenuItem(
                    value: _qaidTableTemplate,
                    child: Text('Features Table')),
                PopupMenuItem(
                    value: _qaidCodeBlockTemplate,
                    child: Text('Flutter Code Block')),
                PopupMenuItem(
                    value: _qaidChecklistTemplate,
                    child: Text('Features Checklist')),
                PopupMenuItem(
                    value: _qaidFootnoteTemplate,
                    child: Text('Footnote Example')),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, size: 20),
              tooltip: 'Clear All',
              onPressed: () => _controller.clear(),
            ),
          ]),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                key: const ValueKey('qaid_markdown_editor_textfield'),
                controller: _controller,
                style: GoogleFonts.firaCode(fontSize: 15, height: 1.6),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start writing your Markdown here...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildPanelHeader(context, "PREVIEW"),
          Expanded(
            child: Markdown(
              data: _controller.text.isEmpty
                  ? "## Preview appears here"
                  : _controller.text,
              selectable: true,
              extensionSet: md.ExtensionSet.gitHubWeb,
              styleSheet: _getMarkdownStyleSheet(context),
              builders: {
                'code': _CodeElementBuilder(
                    isDarkMode ? widget.darkCodeTheme : widget.lightCodeTheme)
              },
              checkboxBuilder: (checked) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  checked
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelHeader(BuildContext context, String title,
      [List<Widget> actions = const []]) {
    final theme = Theme.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: theme.colorScheme.surfaceContainer,
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1)),
          ),
          ...actions,
        ],
      ),
    );
  }

  MarkdownStyleSheet _getMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      h1: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary),
      h2: GoogleFonts.montserrat(
          fontSize: 24, fontWeight: FontWeight.w600, height: 2),
      p: const TextStyle(fontSize: 16, height: 1.5),
      code: GoogleFonts.firaCode(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        color: theme.colorScheme.onSurfaceVariant,
        fontSize: 14,
      ),
      blockquoteDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        border: Border(
            left: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.5), width: 4)),
      ),
      tableBorder: TableBorder.all(
          color: theme.dividerColor, borderRadius: BorderRadius.circular(8)),
      tableCellsPadding: const EdgeInsets.all(12),
      tableHead: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class _CodeElementBuilder extends MarkdownElementBuilder {
  final Map<String, TextStyle> theme;
  _CodeElementBuilder(this.theme);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.children?.isEmpty ?? true) return null;
    final String text = element.children!.first.textContent;
    String language = 'plaintext';
    if (element.attributes['class'] != null) {
      language = element.attributes['class']!.substring(9);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: HighlightView(
          text.trim(),
          language: language,
          theme: theme,
          padding: const EdgeInsets.all(12),
          textStyle: GoogleFonts.firaCode(fontSize: 14, height: 1.5),
        ),
      ),
    );
  }
}



// Qaid Markdown Library by Saher Qaid
// This library contains various types of Markdown content for demonstration and instructional purposes.

// *** FIXED: All internal constants are now private (start with _). ***

const String _qaidMarkdownGuide = '''
# Qaid Markdown Guide 📘

Welcome to **Qaid Markdown**, a modern and professional guide to using all Markdown elements created by *Saher Qaid*.

---

## 🔹 Headers

# H1 Header
## H2 Header
### H3 Header
#### H4 Header
##### H5 Header
###### H6 Header

---

## 🔸 Emphasis

- *Italic*
- **Bold**
- ***Bold Italic***
- ~~Strikethrough~~

---

## 🔹 Lists

### Unordered List:
- Item 1
  - Sub Item 1
  - Sub Item 2
- Item 2

### Ordered List:
1. First item
2. Second item
   1. Sub item
   2. Another sub item
3. Third item

---

## 🔸 Links and Images

[Visit Google](https://www.google.com)

![Flutter Logo](https://flutter.dev/images/flutter-logo-sharing.png)

---

## 🔹 Blockquote

> "Markdown is a lightweight markup language." – Saher Qaid

---

## 🔸 Inline Code

To print in Dart:
`print('Hello World');`

---

## 🔹 Code Block

```dart
void main() {
  print('Welcome to Qaid Markdown Library');
}
```

---

## 🔸 Table

| Feature       | Supported | Example       |
|---------------|-----------|---------------|
| Headers       | ✅        | ## Header     |
| Lists         | ✅        | - Item        |
| Code Blocks   | ✅        | dart          |
| Images        | ✅        | ![alt](url)   |

---

## 🔹 Task List

- [x] Write Markdown guide
- [x] Add tables
- [x] Connect to Flutter

---

## 🔸 Horizontal Rule

---

## 🔹 Footnote

Here is a sentence with a footnote.[^1]

[^1]: This is a footnote created by Saher Qaid.

---

## 🔸 HTML Support

<p style="color: teal; font-size: 18px;">This is a custom styled HTML paragraph inside Markdown.</p>

---

## 🔹 Emoji

Use emoji for expression 🎯🔥🚀🎉

---
''';

const String _qaidTableTemplate = '''
| Feature       | Supported | Notes                        |
|---------------|-----------|------------------------------|
| Bold Text     | ✅        | Using **bold**               |
| Italic Text   | ✅        | Using *italic*               |
| Code Blocks   | ✅        | With triple backticks        |
| Images        | ✅        | Markdown or HTML syntax      |
| Nested Lists  | ✅        | Supported                    |
| HTML Tags     | ✅        | Basic inline only            |
''';

const String _qaidCodeBlockTemplate = '''
// Flutter Example by Saher Qaid
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Qaid Markdown Viewer')),
        body: const Center(child: Text('Welcome to Qaid Markdown!')),
      ),
    );
  }
}
''';

const String _qaidChecklistTemplate = '''
- [x] Add Headings
- [x] Add Lists
- [x] Add Code Blocks
- [x] Add Images
- [x] Add Tables
- [x] Add Footnotes
- [x] Add Blockquotes
- [x] Add Emojis
- [ ] Add Mermaid Diagrams (optional)
- [ ] Add Math Expressions (optional)
''';

const String _qaidFootnoteTemplate = '''
This sentence has a footnote.[^2]

[^2]: A custom footnote written by Saher Qaid for demonstration.
''';
