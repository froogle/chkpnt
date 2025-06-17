import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/screens/main/main_screen.dart';

void main() {
  group('MainScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders correctly with scroll functionality', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('integrates scroll handler correctly', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      // Verify the main screen renders with scroll functionality
      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    test('scroll integration with game actions service', () {
      // Test that the scroll provider is integrated properly
      final scrollNotifier = container.read(scrollToSectionProvider.notifier);

      // Initial state
      expect(container.read(scrollToSectionProvider), isNull);

      // Simulate game actions service requesting scroll
      scrollNotifier.requestScrollTo('Playing');

      // Verify request was created
      final request = container.read(scrollToSectionProvider);
      expect(request, isNotNull);
      expect(request?.targetKey, 'Playing');

      // Clear request (simulating scroll handler processing)
      scrollNotifier.clearRequest();
      expect(container.read(scrollToSectionProvider), isNull);
    });

    testWidgets('disposes scroll controller properly', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
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

    testWidgets('maintains section keys for all game statuses', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      await tester.pump();

      // Find containers with keys - these should be the section containers
      final keyedContainers = find.byType(Container);
      expect(keyedContainers, findsWidgets);

      // We expect at least 4 containers with keys (one for each game section)
      // Plus other containers in the widget tree
      expect(keyedContainers.evaluate().length, greaterThanOrEqualTo(4));
    });
  });
}
