import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/shared/widgets/status_filter_chip.dart';

void main() {
  group('StatusFilterChip', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget buildChips(List<StatusFilterChip> chips) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: Scaffold(body: Row(children: chips))),
      );
    }

    Finder chipNamed(String label) {
      return find.byWidgetPredicate(
        (widget) => widget is StatusFilterChip && widget.label == label,
      );
    }

    BoxDecoration decorationOf(WidgetTester tester, String label) {
      return tester
              .widget<Container>(
                find
                    .descendant(
                      of: chipNamed(label),
                      matching: find.byType(Container),
                    )
                    .first,
              )
              .decoration
          as BoxDecoration;
    }

    TextStyle labelStyleOf(WidgetTester tester, String label) {
      return tester.widget<Text>(find.text(label)).style!;
    }

    Future<void> pumpFormatChips(WidgetTester tester) async {
      await tester.pumpWidget(
        buildChips(const [
          StatusFilterChip(
            label: 'Physical',
            filterType: StatusFilterType.physical,
          ),
          StatusFilterChip(
            label: 'Digital',
            filterType: StatusFilterType.digital,
          ),
        ]),
      );
    }

    Future<void> pumpBacklogChips(WidgetTester tester) async {
      await tester.pumpWidget(
        buildChips(const [
          StatusFilterChip(
            label: 'Backlog',
            filterType: StatusFilterType.backlog,
          ),
          StatusFilterChip(
            label: 'Ongoing',
            filterType: StatusFilterType.ongoing,
          ),
        ]),
      );
    }

    test('is declared at exactly one path under lib/shared/widgets', () {
      final declaringFiles = <String>[];

      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        if (entity.readAsStringSync().contains('class StatusFilterChip')) {
          declaringFiles.add(entity.path);
        }
      }

      expect(declaringFiles, ['lib/shared/widgets/status_filter_chip.dart']);
    });

    testWidgets('paints an active chip in solid orange with white text', (
      tester,
    ) async {
      await pumpFormatChips(tester);

      final decoration = decorationOf(tester, 'Physical');
      expect(decoration.color, Colors.orange);
      expect((decoration.border as Border).top.color, Colors.orange);

      final style = labelStyleOf(tester, 'Physical');
      expect(style.color, Colors.white);
      expect(style.fontWeight, FontWeight.w600);
    });

    testWidgets('paints an inactive chip in translucent orange', (
      tester,
    ) async {
      await pumpFormatChips(tester);

      await tester.tap(chipNamed('Physical'));
      await tester.pump();

      final decoration = decorationOf(tester, 'Physical');
      expect(decoration.color, Colors.orange.withValues(alpha: 0.1));
      expect(
        (decoration.border as Border).top.color,
        Colors.orange.withValues(alpha: 0.3),
      );

      final style = labelStyleOf(tester, 'Physical');
      expect(style.color, Colors.orange.withValues(alpha: 0.8));
      expect(style.fontWeight, FontWeight.w500);
    });

    testWidgets('starts with both format filters on', (tester) async {
      await pumpFormatChips(tester);

      expect(container.read(collectionShowPhysicalFilterProvider), isTrue);
      expect(container.read(collectionShowDigitalFilterProvider), isTrue);
    });

    testWidgets('never allows both format filters to be off', (tester) async {
      await pumpFormatChips(tester);

      await tester.tap(chipNamed('Physical'));
      await tester.pump();
      await tester.tap(chipNamed('Digital'));
      await tester.pump();

      expect(container.read(collectionShowPhysicalFilterProvider), isTrue);
      expect(container.read(collectionShowDigitalFilterProvider), isFalse);

      await tester.tap(chipNamed('Physical'));
      await tester.pump();

      expect(container.read(collectionShowPhysicalFilterProvider), isFalse);
      expect(container.read(collectionShowDigitalFilterProvider), isTrue);
    });

    testWidgets('leaves the backlog filters toggling as before', (
      tester,
    ) async {
      await pumpBacklogChips(tester);

      expect(container.read(backlogShowBacklogFilterProvider), isTrue);
      expect(container.read(backlogShowOngoingFilterProvider), isTrue);

      await tester.tap(chipNamed('Backlog'));
      await tester.pump();

      expect(container.read(backlogShowBacklogFilterProvider), isFalse);
      expect(container.read(backlogShowOngoingFilterProvider), isTrue);
    });

    testWidgets('never allows both backlog filters to be off', (tester) async {
      await pumpBacklogChips(tester);

      await tester.tap(chipNamed('Backlog'));
      await tester.pump();
      await tester.tap(chipNamed('Ongoing'));
      await tester.pump();

      expect(container.read(backlogShowBacklogFilterProvider), isTrue);
      expect(container.read(backlogShowOngoingFilterProvider), isFalse);
    });

    testWidgets('keeps the format filters independent of the backlog ones', (
      tester,
    ) async {
      await pumpFormatChips(tester);

      await tester.tap(chipNamed('Digital'));
      await tester.pump();

      expect(container.read(backlogShowBacklogFilterProvider), isTrue);
      expect(container.read(backlogShowOngoingFilterProvider), isTrue);
    });
  });
}
