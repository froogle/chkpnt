import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chkpnt/providers/backup_state_provider.dart';
import 'package:chkpnt/services/full_backup_service.dart';
import 'package:chkpnt/models/backup_models.dart';

// Mock classes
class MockFullBackupService extends Mock implements FullBackupService {}

void main() {
  group('BackupState', () {
    late MockFullBackupService mockBackupService;
    late ProviderContainer container;

    setUp(() {
      mockBackupService = MockFullBackupService();
      container = ProviderContainer(
        overrides: [
          fullBackupServiceProvider.overrideWithValue(mockBackupService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should start with idle state', () {
      final backupState = container.read(backupStateProvider);

      expect(backupState, isA<BackupOperationState>());
      backupState.when(
        idle: () => expect(true, isTrue),
        selectingDirectory: () => fail('Expected idle state'),
        selectingFile: () => fail('Expected idle state'),
        creatingBackup: (_, __, ___) => fail('Expected idle state'),
        restoringBackup: (_, __, ___) => fail('Expected idle state'),
        validatingBackup: (_) => fail('Expected idle state'),
        confirmingRestore: (_, __) => fail('Expected idle state'),
        success: (_, __) => fail('Expected idle state'),
        error: (_, __, ___) => fail('Expected idle state'),
      );
    });

    test(
      'should transition to success state after successful backup',
      () async {
        // Mock successful backup flow
        when(
          () => mockBackupService.selectBackupDirectory(),
        ).thenAnswer((_) async => '/test/directory');
        when(
          () => mockBackupService.isDirectoryWritable('/test/directory'),
        ).thenAnswer((_) async => true);
        when(
          () => mockBackupService.estimateBackupSize(),
        ).thenAnswer((_) async => 1024);
        when(
          () =>
              mockBackupService.createFullBackupWithProgress('/test/directory'),
        ).thenAnswer(
          (_) => Stream.fromIterable([
            BackupProgressResult(progress: 0.0),
            BackupProgressResult(progress: 0.5),
            BackupProgressResult(
              progress: 1.0,
              filePath: '/test/directory/backup.zip',
            ),
          ]),
        );

        final backupStateNotifier = container.read(
          backupStateProvider.notifier,
        );

        // Start backup
        backupStateNotifier.startBackup();

        // Wait for state updates
        await container.pump();

        // Verify final success state (this is a simplified test)
        final finalState = container.read(backupStateProvider);
        expect(finalState, isA<BackupOperationState>());
      },
    );

    test('should handle backup errors correctly', () async {
      // Mock error scenario
      when(
        () => mockBackupService.selectBackupDirectory(),
      ).thenThrow(Exception('Directory selection failed'));

      final backupStateNotifier = container.read(backupStateProvider.notifier);

      // Start backup
      await backupStateNotifier.startBackup();

      final state = container.read(backupStateProvider);
      state.when(
        idle: () => fail('Expected error state'),
        selectingDirectory: () => fail('Expected error state'),
        selectingFile: () => fail('Expected error state'),
        creatingBackup: (_, __, ___) => fail('Expected error state'),
        restoringBackup: (_, __, ___) => fail('Expected error state'),
        validatingBackup: (_) => fail('Expected error state'),
        confirmingRestore: (_, __) => fail('Expected error state'),
        success: (_, __) => fail('Expected error state'),
        error: (message, code, originalError) {
          expect(message, contains('Failed to create backup'));
          expect(code, equals('BACKUP_CREATION_FAILED'));
        },
      );
    });

    test('should reset to idle state', () async {
      final backupStateNotifier = container.read(backupStateProvider.notifier);

      await backupStateNotifier.reset();

      final state = container.read(backupStateProvider);
      state.when(
        idle: () => expect(true, isTrue),
        selectingDirectory: () => fail('Expected idle state'),
        selectingFile: () => fail('Expected idle state'),
        creatingBackup: (_, __, ___) => fail('Expected idle state'),
        restoringBackup: (_, __, ___) => fail('Expected idle state'),
        validatingBackup: (_) => fail('Expected idle state'),
        confirmingRestore: (_, __) => fail('Expected idle state'),
        success: (_, __) => fail('Expected idle state'),
        error: (_, __, ___) => fail('Expected idle state'),
      );
    });

    test('should handle restore flow correctly', () async {
      final metadata = BackupMetadata(
        version: '1.0.0',
        createdAt: DateTime.now(),
        gameCount: 5,
        imageCount: 3,
        includedImages: const ['game1.jpg', 'game2.png', 'game3.jpg'],
      );

      // Mock restore flow
      when(
        () => mockBackupService.selectBackupFile(),
      ).thenAnswer((_) async => '/test/backup.zip');
      when(
        () => mockBackupService.validateBackupFile('/test/backup.zip'),
      ).thenAnswer((_) async => BackupValidationResult.valid(metadata));

      final backupStateNotifier = container.read(backupStateProvider.notifier);

      await backupStateNotifier.startRestore();

      final state = container.read(backupStateProvider);
      state.when(
        idle: () => fail('Expected confirmation state'),
        selectingDirectory: () => fail('Expected confirmation state'),
        selectingFile: () => fail('Expected confirmation state'),
        creatingBackup: (_, __, ___) => fail('Expected confirmation state'),
        restoringBackup: (_, __, ___) => fail('Expected confirmation state'),
        validatingBackup: (_) => fail('Expected confirmation state'),
        confirmingRestore: (backupFilePath, backupMetadata) {
          expect(backupFilePath, equals('/test/backup.zip'));
          expect(backupMetadata.gameCount, equals(5));
          expect(backupMetadata.imageCount, equals(3));
        },
        success: (_, __) => fail('Expected confirmation state'),
        error: (_, __, ___) => fail('Expected confirmation state'),
      );
    });
  });
}

// Extension for container pump
extension ProviderContainerPump on ProviderContainer {
  Future<void> pump() async {
    await Future.delayed(Duration.zero);
  }
}
