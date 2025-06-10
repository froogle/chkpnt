import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chkpnt/shared/widgets/inputs/compact_search_bar.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

void main() {
  group('CompactSearchBar', () {
    testWidgets('renders correctly with default props', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: CompactSearchBar())),
        ),
      );

      expect(find.byType(CompactSearchBar), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search games...'), findsOneWidget);
    });

    testWidgets('displays custom hint text when provided', (tester) async {
      const customHint = 'Find your games...';

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CompactSearchBar(hintText: customHint)),
          ),
        ),
      );

      expect(find.text(customHint), findsOneWidget);
    });

    testWidgets('updates search query when text is entered', (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: CompactSearchBar())),
        ),
      );

      // Initially, search query should be empty
      expect(container.read(searchQueryProvider), equals(''));

      // Enter text in search field
      await tester.enterText(find.byType(TextField), 'dark');
      await tester.pump();

      // Verify search query is updated
      expect(container.read(searchQueryProvider), equals('dark'));

      container.dispose();
    });

    testWidgets('does not show clear button when search is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: CompactSearchBar())),
        ),
      );

      // Should not find clear button when search is empty
      expect(find.byIcon(Icons.clear_rounded), findsNothing);
    });

    testWidgets('shows clear button when search has text', (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: CompactSearchBar())),
        ),
      );

      // Enter text to trigger clear button appearance
      await tester.enterText(find.byType(TextField), 'dark');
      await tester.pump();

      // Clear button should now be visible
      expect(find.byIcon(Icons.clear_rounded), findsOneWidget);

      container.dispose();
    });

    testWidgets('clears search when clear button is pressed', (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: CompactSearchBar())),
        ),
      );

      // Enter text first
      await tester.enterText(find.byType(TextField), 'dark');
      await tester.pump();

      // Verify text is entered and clear button is visible
      expect(container.read(searchQueryProvider), equals('dark'));
      expect(find.byIcon(Icons.clear_rounded), findsOneWidget);

      // Tap the clear button
      await tester.tap(find.byIcon(Icons.clear_rounded));
      await tester.pump();

      // Verify search is cleared
      expect(container.read(searchQueryProvider), equals(''));
      expect(find.byIcon(Icons.clear_rounded), findsNothing);

      // Verify text field is also cleared
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals(''));

      container.dispose();
    });

    testWidgets('syncs with provider state changes', (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: CompactSearchBar())),
        ),
      );

      // Programmatically update search query via provider
      container.read(searchQueryProvider.notifier).updateQuery('external');
      await tester.pump();

      // Verify text field shows the updated value
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('external'));

      // Clear button should be visible
      expect(find.byIcon(Icons.clear_rounded), findsOneWidget);

      container.dispose();
    });

    testWidgets('handles read-only mode correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CompactSearchBar(readOnly: true)),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    testWidgets('calls onTap callback when provided', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CompactSearchBar(onTap: () => tapped = true)),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      expect(tapped, isTrue);
    });

    group('Clear Button Styling', () {
      testWidgets('uses correct icon and styling', (tester) async {
        final container = ProviderContainer();

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: Scaffold(body: CompactSearchBar())),
          ),
        );

        // Enter text to show clear button
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Find the clear button
        final clearButton = find.byIcon(Icons.clear_rounded);
        expect(clearButton, findsOneWidget);

        // Verify it's an IconButton
        final iconButton = find.ancestor(
          of: clearButton,
          matching: find.byType(IconButton),
        );
        expect(iconButton, findsOneWidget);

        container.dispose();
      });
    });
  });
}
