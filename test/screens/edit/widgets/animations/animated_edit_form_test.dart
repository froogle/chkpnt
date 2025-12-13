import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/edit/widgets/animations/animated_edit_form.dart';

void main() {
  group('AnimatedEditForm', () {
    testWidgets('renders all children correctly', (tester) async {
      const children = [
        Text('First Item'),
        Text('Second Item'),
        Text('Third Item'),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AnimatedEditForm(children: children)),
        ),
      );

      // Pump and settle to complete animations
      await tester.pumpAndSettle();

      expect(find.text('First Item'), findsOneWidget);
      expect(find.text('Second Item'), findsOneWidget);
      expect(find.text('Third Item'), findsOneWidget);
    });

    testWidgets('handles empty children list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AnimatedEditForm(children: []))),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('creates proper animation structure', (tester) async {
      const children = [Text('Test Animation')];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AnimatedEditForm(children: children)),
        ),
      );

      // Verify that animation widgets are present (MaterialApp adds its own transitions)
      expect(find.byType(FadeTransition), findsAtLeastNWidgets(1));
      expect(find.byType(SlideTransition), findsAtLeastNWidgets(1));
      expect(find.text('Test Animation'), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
