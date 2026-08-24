import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chkpnt/screens/guide_reader/widgets/guide_web_reader_toolbar.dart';
import 'package:chkpnt/styles/global_styles.dart';

void main() {
  group('GuideWebReaderToolbar', () {
    Widget wrap({
      bool canGoBack = false,
      VoidCallback? onBack,
      VoidCallback? onClose,
      VoidCallback? onDelete,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: GuideWebReaderToolbar(
            title: 'Guide Title',
            author: 'Guide Author',
            canGoBack: canGoBack,
            onBack: onBack ?? () {},
            onClose: onClose ?? () {},
            onDelete: onDelete,
          ),
        ),
      );
    }

    testWidgets('renders the title and author', (tester) async {
      await tester.pumpWidget(wrap());

      expect(find.text('Guide Title'), findsOneWidget);
      expect(find.text('by Guide Author'), findsOneWidget);
    });

    testWidgets('uses explicit text colours', (tester) async {
      await tester.pumpWidget(wrap());

      final title = tester.widget<Text>(find.text('Guide Title'));
      final author = tester.widget<Text>(find.text('by Guide Author'));

      expect(title.style?.color, AppColors.primaryText);
      expect(author.style?.color, AppColors.expandIcon);
    });

    testWidgets('disables the back button when it cannot go back', (
      tester,
    ) async {
      var backPressed = false;
      await tester.pumpWidget(wrap(onBack: () => backPressed = true));

      await tester.tap(find.byIcon(Icons.arrow_back));

      expect(backPressed, false);
    });

    testWidgets('invokes onBack when it can go back', (tester) async {
      var backPressed = false;
      await tester.pumpWidget(
        wrap(canGoBack: true, onBack: () => backPressed = true),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));

      expect(backPressed, true);
    });

    testWidgets('invokes onClose', (tester) async {
      var closePressed = false;
      await tester.pumpWidget(wrap(onClose: () => closePressed = true));

      await tester.tap(find.byIcon(Icons.close));

      expect(closePressed, true);
    });

    testWidgets('hides the delete button when onDelete is null', (
      tester,
    ) async {
      await tester.pumpWidget(wrap());

      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('shows and invokes the delete button', (tester) async {
      var deletePressed = false;
      await tester.pumpWidget(wrap(onDelete: () => deletePressed = true));

      await tester.tap(find.byIcon(Icons.delete_outline));

      expect(deletePressed, true);
    });
  });
}
