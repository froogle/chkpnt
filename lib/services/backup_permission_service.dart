import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:chkpnt/services/storage_service.dart';

class BackupPermissionService {
  final StorageService _storageService;

  BackupPermissionService(this._storageService);

  Future<bool> checkStoragePermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final int sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 30) {
        return true;
      } else if (sdkInt >= 23) {
        return await _requestLegacyStoragePermission();
      }

      return true;
    } catch (e) {
      debugPrint('Error checking storage permissions: $e');
      return false;
    }
  }

  Future<bool> _requestLegacyStoragePermission() async {
    final PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final PermissionStatus result = await Permission.storage.request();
      return result.isGranted;
    }

    return false;
  }

  Future<String?> getRecommendedBackupDirectory() async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidBackupDirectory();
      }

      return await _getFallbackBackupDirectory();
    } catch (e) {
      debugPrint('Error getting recommended backup directory: $e');
      return null;
    }
  }

  Future<String?> _getAndroidBackupDirectory() async {
    final Directory downloadsDir = Directory('/storage/emulated/0/Download');
    if (await downloadsDir.exists()) {
      final Directory backupDir = Directory(
        path.join(downloadsDir.path, 'ChkPnt Backups'),
      );
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      return backupDir.path;
    }

    return await _getFallbackBackupDirectory();
  }

  Future<String?> _getFallbackBackupDirectory() async {
    if (Platform.isIOS) {
      // Use Documents directory on iOS for user-accessible files
      final Directory documentsDir = await getApplicationDocumentsDirectory();
      final Directory backupDir = Directory(
        path.join(documentsDir.path, 'ChkPnt Backups'),
      );
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      return backupDir.path;
    }

    final Directory appDir = await _storageService
        .getPersistentStorageDirectory();
    final Directory backupDir = Directory(path.join(appDir.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  Future<String?> selectBackupDirectory() async {
    final bool hasPermission = await checkStoragePermissions();
    if (!hasPermission) {
      throw Exception(
        'Storage permission is required to create backups. Please grant storage access in app settings.',
      );
    }

    try {
      // On iOS, cloud directories often aren't directly writable
      // Use local directory first, then let user export the file
      if (Platform.isIOS) {
        return await getRecommendedBackupDirectory();
      }

      final String? selectedPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select Backup Location',
        lockParentWindow: true,
      );

      if (selectedPath != null) {
        return selectedPath;
      }

      debugPrint(
        'User cancelled directory selection, trying recommended directory',
      );
      return await getRecommendedBackupDirectory();
    } catch (e) {
      debugPrint('File picker failed, trying recommended directory: $e');
      return await getRecommendedBackupDirectory();
    }
  }

  Future<String?> selectBackupFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select Backup File to Restore',
        type: FileType.custom,
        allowedExtensions: ['zip'],
        lockParentWindow: true,
      );

      return result?.files.single.path;
    } catch (e) {
      debugPrint('Error selecting backup file: $e');
      throw Exception('Failed to select backup file: ${e.toString()}');
    }
  }

  Future<bool> isDirectoryWritable(String directoryPath) async {
    try {
      final Directory directory = Directory(directoryPath);

      if (!await directory.exists()) {
        return false;
      }

      final File testFile = File(
        path.join(directoryPath, '.chkpnt_write_test'),
      );
      await testFile.writeAsString('test');
      final bool fileExists = await testFile.exists();

      if (fileExists) {
        await testFile.delete();
      }

      return fileExists;
    } catch (e) {
      return false;
    }
  }

  Future<String?> exportBackupFile(String backupFilePath) async {
    if (Platform.isAndroid) {
      return await _exportBackupFileAndroid(backupFilePath);
    } else {
      return await _exportBackupFileIOS(backupFilePath);
    }
  }

  Future<String?> _exportBackupFileAndroid(String backupFilePath) async {
    try {
      // First, try the traditional file picker approach for local storage
      final String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: path.basename(backupFilePath),
        type: FileType.custom,
        allowedExtensions: ['zip'],
        lockParentWindow: true,
      );

      if (selectedPath != null) {
        // Copy the existing backup file to the selected location
        final File sourceFile = File(backupFilePath);
        await sourceFile.copy(selectedPath);
        return selectedPath;
      }

      // If file picker didn't work (user cancelled or cloud storage not available),
      // fall back to Share Intent which works with all cloud storage providers
      debugPrint('File picker cancelled or unavailable, using share intent');
      return await _shareBackupFileAndroid(backupFilePath);
    } catch (e) {
      debugPrint('File picker failed: $e, falling back to share intent');
      return await _shareBackupFileAndroid(backupFilePath);
    }
  }

  Future<String?> _shareBackupFileAndroid(String backupFilePath) async {
    try {
      final File backupFile = File(backupFilePath);
      final String fileName = path.basename(backupFilePath);

      // Use Share Intent to let user save to any cloud storage app
      final XFile xFile = XFile(
        backupFile.path,
        name: fileName,
        mimeType: 'application/zip',
      );

      await Share.shareXFiles(
        [xFile],
        text: 'ChkPnt backup file: $fileName',
        subject: 'ChkPnt Game Library Backup',
      );

      // Return the original path as share intent doesn't provide destination path
      return backupFilePath;
    } catch (e) {
      debugPrint('Error sharing backup file: $e');
      return null;
    }
  }

  Future<String?> _exportBackupFileIOS(String backupFilePath) async {
    try {
      // Use FilePicker to let user choose where to save the backup
      final String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: path.basename(backupFilePath),
        type: FileType.custom,
        allowedExtensions: ['zip'],
        lockParentWindow: true,
      );

      if (selectedPath != null) {
        // Copy the existing backup file to the selected location
        final File sourceFile = File(backupFilePath);
        await sourceFile.copy(selectedPath);
        return selectedPath;
      }

      return null;
    } catch (e) {
      debugPrint('Error exporting backup file: $e');
      return null;
    }
  }
}
