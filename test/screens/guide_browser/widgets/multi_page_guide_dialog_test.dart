import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/guide_browser/widgets/multi_page_guide_dialog.dart';

void main() {
  group('MultiPageGuideDialog', () {
    testWidgets('displays guide title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageGuideDialog(
              guideTitle: 'Test Guide Title',
              pageCount: 5,
            ),
          ),
        ),
      );

      expect(find.text('Test Guide Title'), findsOneWidget);
    });

    testWidgets('displays page count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageGuideDialog(
              guideTitle: 'Test Guide',
              pageCount: 12,
            ),
          ),
        ),
      );

      expect(find.text('This guide has 12 sections'), findsOneWidget);
    });

    testWidgets('displays estimated time in seconds for small guides', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageGuideDialog(
              guideTitle: 'Test Guide',
              pageCount: 30,
            ),
          ),
        ),
      );

      expect(find.textContaining('~30 seconds'), findsOneWidget);
    });

    testWidgets('displays estimated time in minutes for large guides', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageGuideDialog(
              guideTitle: 'Test Guide',
              pageCount: 90,
            ),
          ),
        ),
      );

      expect(find.textContaining('~2 minutes'), findsOneWidget);
    });

    testWidgets('displays all three action buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageGuideDialog(
              guideTitle: 'Test Guide',
              pageCount: 5,
            ),
          ),
        ),
      );

      expect(find.text('Download Full Guide'), findsOneWidget);
      expect(find.text('Save Current Page Only'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('tapping Download Full Guide returns downloadFull action', (tester) async {
      MultiPageGuideAction? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await MultiPageGuideDialog.show(
                  context,
                  guideTitle: 'Test',
                  pageCount: 5,
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Download Full Guide'));
      await tester.pumpAndSettle();

      expect(result, MultiPageGuideAction.downloadFull);
    });

    testWidgets('tapping Save Current Page Only returns saveCurrentPage action', (tester) async {
      MultiPageGuideAction? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await MultiPageGuideDialog.show(
                  context,
                  guideTitle: 'Test',
                  pageCount: 5,
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Current Page Only'));
      await tester.pumpAndSettle();

      expect(result, MultiPageGuideAction.saveCurrentPage);
    });

    testWidgets('tapping Cancel returns cancel action', (tester) async {
      MultiPageGuideAction? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await MultiPageGuideDialog.show(
                  context,
                  guideTitle: 'Test',
                  pageCount: 5,
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, MultiPageGuideAction.cancel);
    });

    testWidgets('displays Multi-Page Guide header', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageGuideDialog(
              guideTitle: 'Test Guide',
              pageCount: 5,
            ),
          ),
        ),
      );

      expect(find.text('Multi-Page Guide'), findsOneWidget);
    });

    testWidgets('displays info message about options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageGuideDialog(
              guideTitle: 'Test Guide',
              pageCount: 5,
            ),
          ),
        ),
      );

      expect(
        find.text('You can save just this page or download all sections.'),
        findsOneWidget,
      );
    });
  });
}
