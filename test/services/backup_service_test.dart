import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/services/backup_service.dart';
import '../test_helpers.dart';

void main() {
  group('BackupService', () {
    group('Service Creation', () {
      test('should create service with repository', () {
        final repository = TestGameRepository();
        final backupService = BackupService(repository);

        expect(backupService, isA<BackupService>());
      });
    });

    group('Service Interface', () {
      test('should have required methods', () {
        final repository = TestGameRepository();
        final backupService = BackupService(repository);

        // Verify methods exist without calling them
        expect(backupService.createBackup, isA<Function>());
        expect(backupService.restoreFromBackup, isA<Function>());
        expect(backupService.getAvailableBackups, isA<Function>());
        expect(backupService.createAutomaticBackupIfNeeded, isA<Function>());
        expect(backupService.getBackupSizeString, isA<Function>());
      });
    });

    group('Basic Functionality', () {
      test('should be instantiable', () {
        final repository = TestGameRepository();
        expect(() => BackupService(repository), returnsNormally);
      });
    });
  });
}
