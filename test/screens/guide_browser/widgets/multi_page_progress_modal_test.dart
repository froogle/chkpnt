import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/guide_browser/widgets/multi_page_progress_modal.dart';

void main() {
  group('MultiPageProgressModal', () {
    testWidgets('displays guide title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide Title',
              currentPage: 3,
              totalPages: 10,
            ),
          ),
        ),
      );

      expect(find.text('Test Guide Title'), findsOneWidget);
    });

    testWidgets('displays page progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 5,
              totalPages: 10,
            ),
          ),
        ),
      );

      expect(find.text('Page 5 of 10'), findsOneWidget);
    });

    testWidgets('displays percentage complete', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 5,
              totalPages: 10,
            ),
          ),
        ),
      );

      expect(find.text('50% complete'), findsOneWidget);
    });

    testWidgets('displays Downloading Guide header', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 1,
              totalPages: 5,
            ),
          ),
        ),
      );

      expect(find.text('Downloading Guide'), findsOneWidget);
    });

    testWidgets('shows cancel button when onCancel is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 1,
              totalPages: 5,
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('hides cancel button when onCancel is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 1,
              totalPages: 5,
              onCancel: null,
            ),
          ),
        ),
      );

      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('calls onCancel when cancel button is tapped', (tester) async {
      bool cancelCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 1,
              totalPages: 5,
              onCancel: () {
                cancelCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(cancelCalled, true);
    });

    testWidgets('displays progress bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 5,
              totalPages: 10,
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('displays circular progress indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 5,
              totalPages: 10,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('handles 0 total pages gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 0,
              totalPages: 0,
            ),
          ),
        ),
      );

      expect(find.text('0% complete'), findsOneWidget);
    });

    testWidgets('shows 100% when current equals total', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiPageProgressModal(
              guideTitle: 'Test Guide',
              currentPage: 10,
              totalPages: 10,
            ),
          ),
        ),
      );

      expect(find.text('100% complete'), findsOneWidget);
    });
  });

  group('MultiPageProgressController', () {
    testWidgets('isCancelled is false initially', (tester) async {
      late MultiPageProgressController controller;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              controller = MultiPageProgressController(
                context: context,
                guideTitle: 'Test',
                totalPages: 5,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(controller.isCancelled, false);
    });

    testWidgets('isCancelled becomes true when cancel is called', (tester) async {
      late MultiPageProgressController controller;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              controller = MultiPageProgressController(
                context: context,
                guideTitle: 'Test',
                totalPages: 5,
                onCancel: () {},
              );
              return ElevatedButton(
                onPressed: () => controller.show(),
                child: const Text('Show'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(controller.isCancelled, true);
    });
  });
}
