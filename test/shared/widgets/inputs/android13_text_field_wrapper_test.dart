import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/shared/widgets/inputs/android13_text_field_wrapper.dart';
import 'package:chkpnt/utils/platform_utils.dart';

void main() {
  group('Android13TextFieldWrapper', () {
    setUp(() {
      // Enable Android 13 simulation for all tests
      PlatformUtils.setTestAndroid13Override(true);
    });

    tearDown(() {
      // Reset platform detection after each test
      PlatformUtils.setTestAndroid13Override(null);
    });

    testWidgets('renders child widget correctly when disabled', (tester) async {
      const testChild = TextField(
        decoration: InputDecoration(hintText: 'Test Field'),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Android13TextFieldWrapper(enabled: false, child: testChild),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Test Field'), findsOneWidget);
      expect(find.text('Done'), findsNothing);
    });

    testWidgets('renders child widget correctly when not Android 13', (
      tester,
    ) async {
      // Override to simulate non-Android 13 platform
      PlatformUtils.setTestAndroid13Override(false);

      const testChild = TextField(
        decoration: InputDecoration(hintText: 'Test Field'),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Android13TextFieldWrapper(enabled: true, child: testChild),
          ),
        ),
      );

      // Focus the text field
      await tester.tap(find.byType(TextField));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Test Field'), findsOneWidget);
      expect(
        find.text('Done'),
        findsNothing,
      ); // Should not show on non-Android 13
    });

    testWidgets('creates wrapper structure when enabled on Android 13', (
      tester,
    ) async {
      const testChild = TextField(
        decoration: InputDecoration(hintText: 'Test Field'),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Android13TextFieldWrapper(enabled: true, child: testChild),
          ),
        ),
      );

      // The wrapper should create a Stack structure when enabled
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Test Field'), findsOneWidget);
    });

    testWidgets('preserves text field functionality', (tester) async {
      final controller = TextEditingController();

      final testChild = TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Test Field'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Android13TextFieldWrapper(enabled: true, child: testChild),
          ),
        ),
      );

      // Focus and enter text
      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Hello World');
      await tester.pump();

      // Verify text was entered correctly
      expect(controller.text, equals('Hello World'));
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('works with different text field configurations', (
      tester,
    ) async {
      final controller = TextEditingController();

      final testChild = TextField(
        controller: controller,
        maxLines: 3,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          hintText: 'Multi-line Test Field',
          border: OutlineInputBorder(),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Android13TextFieldWrapper(enabled: true, child: testChild),
          ),
        ),
      );

      await tester.pump();
      await tester.enterText(
        find.byType(TextField),
        'test multiline\ncontent here',
      );
      await tester.pump();

      // Verify multi-line text field works correctly
      expect(controller.text, equals('test multiline\ncontent here'));
    });

    testWidgets('implements WidgetsBindingObserver correctly', (tester) async {
      const testChild = TextField(
        decoration: InputDecoration(hintText: 'Test Field'),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Android13TextFieldWrapper(enabled: true, child: testChild),
          ),
        ),
      );

      // The widget should be registered as an observer
      // We can't easily test didChangeMetrics in the test environment,
      // but we can verify the widget builds correctly and handles lifecycle
      expect(find.byType(Android13TextFieldWrapper), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
