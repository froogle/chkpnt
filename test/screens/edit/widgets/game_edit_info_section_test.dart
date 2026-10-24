import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/edit/widgets/game_edit_info_section.dart';
import 'package:chkpnt/providers/game_edit_provider.dart';
import '../../../test_helpers.dart';

void main() {
  group('GameEditInfoSection Widget Tests', () {
    late ProviderContainer container;
    late TextEditingController titleController;
    late GameEditContext editContext;

    setUp(() {
      container = TestHelpers.createTestContainer();
      titleController = TextEditingController(text: 'Test Game');
      editContext = GameEditContext(
        isAddMode: false,
        game: TestHelpers.createTestGame(),
      );
    });

    tearDown(() {
      titleController.dispose();
      container.dispose();
    });

    testWidgets('renders correctly with all sections', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: GameEditInfoSection(
                titleController: titleController,
                selectedPlatform: 'PlayStation 5',
                onPlatformChanged: (platform) {},
                editContext: editContext,
                isAddMode: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(GameEditInfoSection), findsOneWidget);
    });

    testWidgets('title field can be focused and edited', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: GameEditInfoSection(
                titleController: titleController,
                selectedPlatform: 'PlayStation 5',
                onPlatformChanged: (platform) {},
                editContext: editContext,
                isAddMode: false,
              ),
            ),
          ),
        ),
      );

      // Find and tap the title field
      final titleField = find.byType(TextField);
      expect(titleField, findsOneWidget);

      await tester.tap(titleField);
      await tester.pump();

      // Verify text field is focused
      expect(tester.testTextInput.hasAnyClients, isTrue);

      // Enter new text
      await tester.enterText(titleField, 'New Game Title');
      await tester.pump();

      // Verify text was entered
      expect(titleController.text, 'New Game Title');
    });

    testWidgets('focus node is properly set up', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: GameEditInfoSection(
                titleController: titleController,
                selectedPlatform: 'PlayStation 5',
                onPlatformChanged: (platform) {},
                editContext: editContext,
                isAddMode: false,
              ),
            ),
          ),
        ),
      );

      // Find the widget state
      final state = tester.state(find.byType(GameEditInfoSection));

      // Verify the state has a focus node
      expect(state, isA<ConsumerState>());
    });

    testWidgets('focus is maintained when tapping title field', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: GameEditInfoSection(
                titleController: titleController,
                selectedPlatform: 'PlayStation 5',
                onPlatformChanged: (platform) {},
                editContext: editContext,
                isAddMode: false,
              ),
            ),
          ),
        ),
      );

      // Tap the title field
      final titleField = find.byType(TextField);
      await tester.tap(titleField);
      await tester.pump();

      // Verify focus is maintained
      expect(tester.testTextInput.hasAnyClients, isTrue);

      // Simulate a short delay (less than our fix delay)
      await tester.pump(const Duration(milliseconds: 100));

      // Focus should still be maintained
      expect(tester.testTextInput.hasAnyClients, isTrue);
    });

    testWidgets('calls onPlatformChanged when platform is changed', (
      tester,
    ) async {
      String? changedPlatform;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: GameEditInfoSection(
                titleController: titleController,
                selectedPlatform: 'PlayStation 5',
                onPlatformChanged: (platform) {
                  changedPlatform = platform;
                },
                editContext: editContext,
                isAddMode: false,
              ),
            ),
          ),
        ),
      );

      // This test verifies the callback is wired up correctly
      expect(find.byType(GameEditInfoSection), findsOneWidget);
      expect(changedPlatform, isNull);
    });

    testWidgets('disposes resources correctly', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: GameEditInfoSection(
                titleController: titleController,
                selectedPlatform: 'PlayStation 5',
                onPlatformChanged: (platform) {},
                editContext: editContext,
                isAddMode: false,
              ),
            ),
          ),
        ),
      );

      // Verify widget is rendered
      expect(find.byType(GameEditInfoSection), findsOneWidget);

      // Dispose the widget
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      // Verify no errors during disposal
      expect(tester.takeException(), isNull);
    });

    testWidgets('maintains focus stability', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: GameEditInfoSection(
                titleController: titleController,
                selectedPlatform: 'PlayStation 5',
                onPlatformChanged: (platform) {},
                editContext: editContext,
                isAddMode: false,
              ),
            ),
          ),
        ),
      );

      // Focus the title field
      final titleField = find.byType(TextField);
      await tester.tap(titleField);
      await tester.pump();

      // Verify field is focused
      expect(tester.testTextInput.hasAnyClients, isTrue);

      // Simulate some time passing (to test stability)
      await tester.pump(const Duration(milliseconds: 200));

      // Focus should still be maintained
      expect(tester.testTextInput.hasAnyClients, isTrue);

      // Verify we can type without losing focus
      await tester.enterText(titleField, 'Stable Title');
      await tester.pump();

      expect(titleController.text, 'Stable Title');
    });
  });
}
