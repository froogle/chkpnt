import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/profile/widgets/profile_backup_section.dart';
import 'package:chkpnt/providers/backup_state_provider.dart';
import 'package:chkpnt/models/backup_models.dart';

void main() {
  group('ProfileBackupSection', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget({BackupOperationState? initialState}) {
      return ProviderScope(
        parent: container,
        overrides: initialState != null
            ? [
                backupStateProvider.overrideWith(() => MockBackupState(initialState)),
              ]
            : [],
        child: const MaterialApp(
          home: Scaffold(
            body: ProfileBackupSection(),
          ),
        ),
      );
    }

    testWidgets('should display backup section in idle state', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Backup & Restore'), findsOneWidget);
      expect(find.text('Create Backup'), findsOneWidget);
      expect(find.text('Restore Backup'), findsOneWidget);
      expect(find.text('Create a complete backup of your games library and images, or restore from a previous backup.'), findsOneWidget);
    });

    testWidgets('should display progress state correctly', (WidgetTester tester) async {
      const progressState = BackupOperationState.creatingBackup(
        progress: 0.5,
        currentStep: 'Creating archive...',
        statusMessage: 'Processing images...',
      );

      await tester.pumpWidget(createTestWidget(initialState: progressState));

      expect(find.text('Creating Backup'), findsOneWidget);
      expect(find.text('Creating archive...'), findsOneWidget);
      expect(find.text('Processing images...'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error state correctly', (WidgetTester tester) async {
      const errorState = BackupOperationState.error(
        message: 'Failed to create backup',
        code: 'BACKUP_CREATION_FAILED',
      );

      await tester.pumpWidget(createTestWidget(initialState: errorState));

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Failed to create backup'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display success state correctly', (WidgetTester tester) async {
      const successState = BackupOperationState.success(
        message: 'Backup created successfully!',
        filePath: '/path/to/backup.zip',
      );

      await tester.pumpWidget(createTestWidget(initialState: successState));

      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('Backup created successfully!'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outlined), findsOneWidget);
    });

    testWidgets('should display confirmation state with metadata', (WidgetTester tester) async {
      final metadata = BackupMetadata(
        version: '1.0.0',
        createdAt: DateTime(2024, 1, 15, 10, 30),
        gameCount: 5,
        imageCount: 3,
        includedImages: const ['game1.jpg', 'game2.png', 'game3.jpg'],
      );

      final confirmState = BackupOperationState.confirmingRestore(
        backupFilePath: '/path/to/backup.zip',
        metadata: metadata,
      );

      await tester.pumpWidget(createTestWidget(initialState: confirmState));

      expect(find.text('Confirm Restore'), findsOneWidget);
      expect(find.text('5'), findsOneWidget); // Game count
      expect(find.text('3'), findsOneWidget); // Image count
      expect(find.text('15/1/2024'), findsOneWidget); // Date
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Restore'), findsOneWidget);
    });

    testWidgets('should display loading states correctly', (WidgetTester tester) async {
      const selectingState = BackupOperationState.selectingDirectory();

      await tester.pumpWidget(createTestWidget(initialState: selectingState));

      expect(find.text('Selecting backup location...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

// Mock backup state provider for testing
class MockBackupState extends BackupState {
  final BackupOperationState _state;

  MockBackupState(this._state);

  @override
  BackupOperationState build() => _state;
}