import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chkpnt/screens/guide_reader/widgets/attribution_modal.dart';
import 'package:chkpnt/styles/dialog_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';

void main() {
  group('AttributionModal', () {
    Widget wrap({VoidCallback? onDismiss}) {
      return MaterialApp(
        home: Scaffold(
          body: AttributionModal(onDismiss: onDismiss ?? () {}),
        ),
      );
    }

    testWidgets('renders its heading and body', (tester) async {
      await tester.pumpWidget(wrap());

      expect(find.text('Thank the maker!'), findsOneWidget);
      expect(find.textContaining('volunteers'), findsOneWidget);
    });

    group('explicit styling for Android 13 visibility', () {
      testWidgets('declares an explicit background and surface tint', (
        tester,
      ) async {
        await tester.pumpWidget(wrap());

        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.backgroundColor, equals(AppDialogStyles.backgroundColor));
        expect(dialog.surfaceTintColor, equals(Colors.transparent));
      });

      testWidgets('heading declares an explicit colour', (tester) async {
        await tester.pumpWidget(wrap());

        final heading = tester.widget<Text>(find.text('Thank the maker!'));
        expect(heading.style?.color, isNotNull);
        expect(heading.style?.color, equals(AppColors.primaryText));
      });

      testWidgets('body text declares an explicit colour', (tester) async {
        await tester.pumpWidget(wrap());

        final body = tester.widget<Text>(find.textContaining('volunteers'));
        expect(body.style?.color, isNotNull);
        expect(body.style?.color, equals(AppColors.primaryText));
      });
    });
  });
}
