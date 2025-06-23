import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/backlog/backlog_screen.dart';

void main() {
  group('BacklogScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders correctly and shows empty state by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
        ),
      );

      // Verify the backlog screen renders
      expect(find.byType(BacklogScreen), findsOneWidget);

      // Should show empty state when no games present
      expect(find.text('No games in backlog'), findsOneWidget);
      expect(find.text('Add some games to get started!'), findsOneWidget);
    });

    testWidgets('disposes scroll controller properly', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
        ),
      );

      await tester.pump();

      // Navigate away to trigger dispose
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: Text('Other Screen'))),
        ),
      );

      // No exception should be thrown during dispose
    });
  });
}
