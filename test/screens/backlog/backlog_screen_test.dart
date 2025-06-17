import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
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

    testWidgets('renders correctly with scroll handler integration', (
      tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
        ),
      );

      // Verify the backlog screen renders with scroll handler integration
      expect(find.byType(BacklogScreen), findsOneWidget);
      // The ScrollView is only present when there are games, so we just verify the screen renders
    });

    test('scroll integration with platform-based scrolling', () {
      // Test that the scroll provider is integrated properly for platforms
      final scrollNotifier = container.read(scrollToSectionProvider.notifier);

      // Initial state
      expect(container.read(scrollToSectionProvider), isNull);

      // Simulate platform-based scroll request (from backlog screen)
      scrollNotifier.requestScrollTo('PlayStation 5');

      // Verify request was created for platform
      final request = container.read(scrollToSectionProvider);
      expect(request, isNotNull);
      expect(request?.targetKey, 'PlayStation 5');

      // Clear request (simulating scroll handler processing)
      scrollNotifier.clearRequest();
      expect(container.read(scrollToSectionProvider), isNull);
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
