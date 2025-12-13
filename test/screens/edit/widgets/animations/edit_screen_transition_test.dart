import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/edit/widgets/animations/edit_screen_transition.dart';

void main() {
  group('EditScreenTransition', () {
    testWidgets('renders child widget correctly', (tester) async {
      final animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: const TestVSync(),
      );
      final secondaryAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: const TestVSync(),
      );

      const testChild = Text('Test Content');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditScreenTransition(
              animation: animationController,
              secondaryAnimation: secondaryAnimationController,
              child: testChild,
            ),
          ),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
      // MaterialApp adds its own page transitions, so we check for at least 2
      expect(find.byType(SlideTransition), findsAtLeastNWidgets(2));

      animationController.dispose();
      secondaryAnimationController.dispose();
    });

    testWidgets('creates proper slide transitions', (tester) async {
      final animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: const TestVSync(),
      );
      final secondaryAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: const TestVSync(),
      );

      const testChild = Text('Animated Content');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditScreenTransition(
              animation: animationController,
              secondaryAnimation: secondaryAnimationController,
              child: testChild,
            ),
          ),
        ),
      );

      // Verify the transition structure (MaterialApp adds its own page transitions)
      expect(find.byType(SlideTransition), findsAtLeastNWidgets(2));
      expect(find.text('Animated Content'), findsOneWidget);

      animationController.dispose();
      secondaryAnimationController.dispose();
    });
  });
}
