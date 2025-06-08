import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';

void main() {
  group('EditScreenPageRoute', () {
    testWidgets('creates route with correct properties', (tester) async {
      const testChild = Text('Test Widget');

      final route = EditScreenPageRoute(
        child: testChild,
        duration: const Duration(milliseconds: 300),
      );

      expect(route.transitionDuration, const Duration(milliseconds: 300));
      expect(
        route.reverseTransitionDuration,
        const Duration(milliseconds: 300),
      );
    });

    testWidgets('uses default duration when not specified', (tester) async {
      const testChild = Text('Test Widget');

      final route = EditScreenPageRoute(child: testChild);

      expect(route.transitionDuration, const Duration(milliseconds: 400));
      expect(
        route.reverseTransitionDuration,
        const Duration(milliseconds: 400),
      );
    });

    testWidgets('renders child widget correctly', (tester) async {
      const testChild = Text('Test Content');

      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(body: Text('Initial')),
          routes: {'/test': (context) => const Scaffold(body: testChild)},
        ),
      );

      final route = EditScreenPageRoute(child: const Scaffold(body: testChild));

      await tester.pumpWidget(
        MaterialApp(home: Navigator(onGenerateRoute: (settings) => route)),
      );

      await tester.pump();
      expect(find.text('Test Content'), findsOneWidget);
    });
  });
}
