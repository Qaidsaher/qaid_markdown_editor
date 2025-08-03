import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qaid_markdown_editor/qaid_markdown_editor.dart';

Widget buildTestableWidget({required Widget child}) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

Future<void> setScreenSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('QaidMarkdownEditor', () {
    testWidgets('renders side-by-side panels on a wide screen',
        (WidgetTester tester) async {
      await setScreenSize(tester, const Size(1200, 900));
      await tester
          .pumpWidget(buildTestableWidget(child: const QaidMarkdownEditor()));
      expect(find.text('EDITOR'), findsOneWidget);
      expect(find.text('PREVIEW'), findsOneWidget);
    });

    testWidgets('renders a TabBar on a narrow screen',
        (WidgetTester tester) async {
      await setScreenSize(tester, const Size(500, 900));
      await tester
          .pumpWidget(buildTestableWidget(child: const QaidMarkdownEditor()));
      expect(find.byType(TabBar), findsOneWidget);
    });

    // THIS TEST IS NOW CORRECTED
    testWidgets('can be controlled by an external TextEditingController',
        (WidgetTester tester) async {
      await setScreenSize(tester, const Size(1200, 900));
      final controller = TextEditingController(text: 'Initial');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestableWidget(child: QaidMarkdownEditor(controller: controller)),
      );

      final textFieldFinder =
          find.byKey(const ValueKey('qaid_markdown_editor_textfield'));
      expect(textFieldFinder, findsOneWidget);
      expect(
          find.descendant(of: textFieldFinder, matching: find.text('Initial')),
          findsOneWidget);

      controller.text = 'Updated';
      await tester.pump();
      expect(
          find.descendant(of: textFieldFinder, matching: find.text('Updated')),
          findsOneWidget);
    });

    testWidgets('displays custom title and actions in AppBar',
        (WidgetTester tester) async {
      await setScreenSize(tester, const Size(1200, 900));
      await tester.pumpWidget(
        MaterialApp(
          home: QaidMarkdownEditor(
            title: const Text('My Doc'),
            actions: [
              IconButton(icon: const Icon(Icons.favorite), onPressed: () {})
            ],
          ),
        ),
      );
      expect(find.text('My Doc'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('displays help button and opens dialog on tap',
        (WidgetTester tester) async {
      await setScreenSize(tester, const Size(1200, 900));
      await tester
          .pumpWidget(buildTestableWidget(child: const QaidMarkdownEditor()));
      await tester.tap(find.byIcon(Icons.help_outline));
      await tester.pumpAndSettle();
      expect(find.text('Markdown Guide'), findsOneWidget);
    });

    testWidgets('template menu inserts text into the editor',
        (WidgetTester tester) async {
      await setScreenSize(tester, const Size(1200, 900));
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        buildTestableWidget(child: QaidMarkdownEditor(controller: controller)),
      );
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Features Table'));
      await tester.pumpAndSettle();
      expect(controller.text, contains('Feature'));
    });
  });
}
