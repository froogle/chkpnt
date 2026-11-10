import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chkpnt/shared/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:chkpnt/styles/dialog_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';

void main() {
  group('ConfirmDeleteDialog', () {
    Widget wrap({String title = 'Delete Game', String itemName = 'Lufia'}) {
      return MaterialApp(
        home: Scaffold(
          body: ConfirmDeleteDialog(title: title, itemName: itemName),
        ),
      );
    }

    testWidgets('renders the title and the item name', (tester) async {
      await tester.pumpWidget(wrap());

      expect(find.text('Delete Game'), findsOneWidget);
      expect(find.textContaining('Lufia'), findsOneWidget);
      expect(find.textContaining('cannot be undone'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('is reusable for other item types', (tester) async {
      await tester.pumpWidget(
        wrap(title: 'Delete Guide', itemName: 'Sea Of Stars'),
      );

      expect(find.text('Delete Guide'), findsOneWidget);
      expect(find.textContaining('Sea Of Stars'), findsOneWidget);
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

      testWidgets('title and content declare explicit colours', (tester) async {
        await tester.pumpWidget(wrap());

        final title = tester.widget<Text>(find.text('Delete Game'));
        expect(title.style?.color, equals(AppColors.primaryText));

        final content = tester.widget<Text>(
          find.textContaining('cannot be undone'),
        );
        expect(content.style?.color, equals(AppColors.primaryText));
      });

      testWidgets('actions declare explicit foreground colours', (
        tester,
      ) async {
        await tester.pumpWidget(wrap());

        for (final label in ['Cancel', 'Delete']) {
          final button = tester.widget<TextButton>(
            find.widgetWithText(TextButton, label),
          );
          final foreground = button.style?.foregroundColor?.resolve(
            <WidgetState>{},
          );
          expect(foreground, isNotNull, reason: '$label needs a colour');
          expect(foreground, isNot(equals(Colors.white)));
        }
      });

      testWidgets('the destructive action is visually distinct', (
        tester,
      ) async {
        await tester.pumpWidget(wrap());

        final cancel = tester.widget<TextButton>(
          find.widgetWithText(TextButton, 'Cancel'),
        );
        final delete = tester.widget<TextButton>(
          find.widgetWithText(TextButton, 'Delete'),
        );

        expect(
          delete.style?.foregroundColor?.resolve(<WidgetState>{}),
          equals(AppDialogStyles.destructiveButtonColor),
        );
        expect(
          cancel.style?.foregroundColor?.resolve(<WidgetState>{}),
          isNot(equals(AppDialogStyles.destructiveButtonColor)),
        );
      });
    });

    group('result', () {
      Future<bool?> openAndTap(WidgetTester tester, String label) async {
        bool? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await ConfirmDeleteDialog.show(
                      context,
                      title: 'Delete Game',
                      itemName: 'Lufia',
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();

        return result;
      }

      testWidgets('returns true when Delete is tapped', (tester) async {
        expect(await openAndTap(tester, 'Delete'), isTrue);
      });

      testWidgets('returns false when Cancel is tapped', (tester) async {
        expect(await openAndTap(tester, 'Cancel'), isFalse);
      });

      testWidgets('returns false when dismissed by tapping the barrier', (
        tester,
      ) async {
        bool? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await ConfirmDeleteDialog.show(
                      context,
                      title: 'Delete Game',
                      itemName: 'Lufia',
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(
          result,
          isFalse,
          reason: 'a dismissed dialog must not read as confirmation',
        );
      });
    });
  });
}
