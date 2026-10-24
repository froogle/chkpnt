import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/shared/widgets/inputs/platform_filter_dropdown.dart';

void main() {
  group('PlatformFilterDropdown', () {
    late List<String?> reported;

    setUp(() {
      reported = [];
    });

    Future<void> openMenu(
      WidgetTester tester, {
      required String? selectedPlatform,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformFilterDropdown(
              selectedPlatform: selectedPlatform,
              platforms: const ['PC', 'PS5'],
              onPlatformChanged: reported.add,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(PlatformFilterDropdown));
      await tester.pumpAndSettle();
    }

    testWidgets('offers All before the Platforms', (tester) async {
      await openMenu(tester, selectedPlatform: null);

      final menuLabels = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(PopupMenuItem<int>),
              matching: find.byType(Text),
            ),
          )
          .map((text) => text.data);
      expect(menuLabels, ['All', 'PC', 'PS5']);
      expect(find.text('All'), findsNWidgets(2));
    });

    testWidgets('reports no Platform when All is picked', (tester) async {
      await openMenu(tester, selectedPlatform: 'PC');

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(reported, [null]);
    });

    testWidgets('reports the Platform picked', (tester) async {
      await openMenu(tester, selectedPlatform: null);

      await tester.tap(find.text('PS5'));
      await tester.pumpAndSettle();

      expect(reported, ['PS5']);
    });
  });
}
