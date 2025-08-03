import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package.markdown/markdown.dart' as md;

/// A professional, highly customizable Markdown editor widget for Flutter.
///
/// Features a live preview, syntax highlighting, and custom action buttons,
/// presented in a modern, professional UI.
class QaidMarkdownEditor extends StatefulWidget {
  /// A controller to manage the text being edited.
  /// If you don't provide one, a default controller will be created internally.
  final TextEditingController? controller;

  /// The initial text to display in the editor.
  /// This is only used if a [controller] is not provided.
  final String? initialValue;

  /// The widget to display as the title in the AppBar.
  final Widget? title;

  /// A list of additional actions to add to the AppBar.
  final List<Widget>? actions;

  /// The syntax highlighting theme to use for code blocks in light mode.
  final Map<String, TextStyle> lightCodeTheme;

  /// The syntax highlighting theme to use for code blocks in dark mode.
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

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue);
    }
    _controller.addListener(() => setState(() {}));
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
    final selection = _controller.selection;
    final newText = _controller.text
        .replaceRange(selection.start, selection.end, textToInsert);
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.fromPosition(
          TextPosition(offset: selection.start + textToInsert.length)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: widget.actions,
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
  }

  Widget _buildWideLayout(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: _buildEditorPanel(context)),
            const SizedBox(width: 8),
            Expanded(child: _buildPreviewPanel(context)),
          ],
        ),
      );

  Widget _buildNarrowLayout(BuildContext context) => TabBarView(
        controller: _tabController,
        children: [_buildEditorPanel(context), _buildPreviewPanel(context)],
      );

  Widget _buildEditorPanel(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
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
                PopupMenuItem(value: _tableTemplate, child: Text('Table')),
                PopupMenuItem(
                    value: _codeBlockTemplate, child: Text('Code Block')),
                PopupMenuItem(
                    value: _checklistTemplate, child: Text('Checklist')),
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
      margin: const EdgeInsets.all(8.0),
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
          Text(title,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1)),
          const Spacer(),
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

// Private helper classes and constants.
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

const String _tableTemplate = """
| Plan      | Price/Month | Features                  |
|:----------|:-----------:|:--------------------------|
| **Free**  |     \$0     | Basic Editing, 1 Project  |
| **Pro**   |     \$10    | Advanced Editing, 10 Projects, Cloud Sync |
""";

const String _codeBlockTemplate = """
```javascript
function greet(name) {
  console.log(`Hello, ${name}!`);
}
""";
const String _checklistTemplate = """
Design the UI
Implement the logic
Write tests
""";