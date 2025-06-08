import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/edit/widgets/image_selection_bottom_sheet.dart';
import 'package:chkpnt/services/game_image_service.dart';

void main() {
  group('ImageSelectionBottomSheet', () {
    testWidgets('renders correctly with basic options', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: ImageSelectionBottomSheet(hasExistingImage: false),
          ),
        ),
      );

      // Check header elements
      expect(find.text('Select Image'), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));

      // Check main options
      expect(find.text('Photo Gallery'), findsOneWidget);
      expect(find.text('Choose from your photos'), findsOneWidget);
      expect(find.text('File Browser'), findsOneWidget);
      expect(find.text('Choose from files'), findsOneWidget);

      // Check icons
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsOneWidget);
    });

    testWidgets('shows remove option when hasExistingImage is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: ImageSelectionBottomSheet(hasExistingImage: true),
          ),
        ),
      );

      // Check that remove option is visible
      expect(find.text('Remove Image'), findsOneWidget);
      expect(find.text('Use placeholder instead'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('hides remove option when hasExistingImage is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: ImageSelectionBottomSheet(hasExistingImage: false),
          ),
        ),
      );

      // Check that remove option is not visible
      expect(find.text('Remove Image'), findsNothing);
      expect(find.text('Use placeholder instead'), findsNothing);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('photo gallery option is tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed:
                        () => showModalBottomSheet<dynamic>(
                          context: context,
                          builder:
                              (_) => const ImageSelectionBottomSheet(
                                hasExistingImage: false,
                              ),
                        ),
                    child: const Text('Show Sheet'),
                  ),
            ),
          ),
        ),
      );

      // Open the bottom sheet
      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Tap photo gallery option
      await tester.tap(find.text('Photo Gallery'));
      await tester.pumpAndSettle();

      // Bottom sheet should be closed (no longer visible)
      expect(find.text('Photo Gallery'), findsNothing);
    });

    testWidgets('file browser option is tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed:
                        () => showModalBottomSheet<dynamic>(
                          context: context,
                          builder:
                              (_) => const ImageSelectionBottomSheet(
                                hasExistingImage: false,
                              ),
                        ),
                    child: const Text('Show Sheet'),
                  ),
            ),
          ),
        ),
      );

      // Open the bottom sheet
      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Tap file browser option
      await tester.tap(find.text('File Browser'));
      await tester.pumpAndSettle();

      // Bottom sheet should be closed
      expect(find.text('File Browser'), findsNothing);
    });

    testWidgets('remove option is tappable when visible', (tester) async {
      // Set a larger test size to avoid overflow
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed:
                        () => showModalBottomSheet<dynamic>(
                          context: context,
                          isScrollControlled: true,
                          builder:
                              (_) => const ImageSelectionBottomSheet(
                                hasExistingImage: true,
                              ),
                        ),
                    child: const Text('Show Sheet'),
                  ),
            ),
          ),
        ),
      );

      // Open the bottom sheet
      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Tap remove option
      await tester.tap(find.text('Remove Image'));
      await tester.pumpAndSettle();

      // Bottom sheet should be closed
      expect(find.text('Remove Image'), findsNothing);
    });

    testWidgets('has proper styling and layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: ImageSelectionBottomSheet(hasExistingImage: true),
          ),
        ),
      );

      // Check that there are InkWell widgets for interaction
      expect(find.byType(InkWell), findsAtLeastNWidgets(3)); // 3 options

      // Check that there are proper spacing elements
      expect(find.byType(SizedBox), findsAtLeastNWidgets(3));

      // Check that icons have proper containers
      final iconContainers = find.descendant(
        of: find.byType(InkWell),
        matching: find.byType(Container),
      );
      expect(iconContainers, findsAtLeastNWidgets(3));
    });

    group('Static show method', () {
      testWidgets('can be called and shows bottom sheet', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed:
                          () => ImageSelectionBottomSheet.show(
                            context: context,
                            hasExistingImage: false,
                          ),
                      child: const Text('Show Sheet'),
                    ),
              ),
            ),
          ),
        );

        // Tap to show sheet
        await tester.tap(find.text('Show Sheet'));
        await tester.pumpAndSettle();

        // Check that bottom sheet is visible
        expect(find.text('Select Image'), findsOneWidget);
        expect(find.text('Photo Gallery'), findsOneWidget);
      });

      testWidgets('returns proper result when gallery is selected', (
        tester,
      ) async {
        dynamic result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed: () async {
                        result = await ImageSelectionBottomSheet.show(
                          context: context,
                          hasExistingImage: false,
                        );
                      },
                      child: const Text('Show Sheet'),
                    ),
              ),
            ),
          ),
        );

        // Show sheet and select gallery
        await tester.tap(find.text('Show Sheet'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Photo Gallery'));
        await tester.pumpAndSettle();

        // Check result
        expect(result, equals(GameImageSource.gallery));
      });
    });
  });
}
