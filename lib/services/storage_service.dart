import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  static const String _appDirectoryName = 'ChkPnt';
  static const Duration _deviceInfoTimeout = Duration(seconds: 5);

  /// Get the most persistent storage directory for each platform
  ///
  /// This hybrid strategy balances data persistence with Android 14+ compatibility:
  /// - iOS/macOS: Uses Application Support Directory (persists across updates, backed up to iCloud)
  /// - Android: Uses External Storage when possible for development persistence,
  ///   with Application Support fallback for Android 14+ permission compatibility
  /// - Other platforms: Falls back to Application Support Directory
  Future<Directory> getPersistentStorageDirectory() async {
    return await _getPersistentDirectory();
  }

  /// Get the persistent backup directory that matches database storage location
  ///
  /// This ensures backups are stored in the same persistent location as the database
  /// and survive app updates and debugging sessions
  Future<Directory> getPersistentBackupDirectory() async {
    final baseDir = await _getPersistentDirectory();
    return await _createSubdirectory(baseDir, 'backups');
  }

  /// Check if the current Android version is 14 (API 34) or later
  /// This helps determine the appropriate storage strategy
  Future<bool> isAndroid14OrLater() async {
    try {
      if (!Platform.isAndroid) return false;

      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo.timeout(
        _deviceInfoTimeout,
        onTimeout: () => throw TimeoutException('Device info timeout'),
      );

      // Android 14 is API level 34
      final sdkInt = androidInfo.version.sdkInt;
      return sdkInt >= 34;
    } catch (e) {
      // If we can't determine the version, assume it's a newer version for safety
      debugPrint('Failed to determine Android version: $e');
      return true;
    }
  }

  /// Core method to get the most persistent directory for the current platform
  Future<Directory> _getPersistentDirectory() async {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        return await _getAppleStorageDirectory();
      }

      if (Platform.isAndroid) {
        return await _getAndroidStorageDirectory();
      }

      return await _getDefaultStorageDirectory();
    } catch (e) {
      return await _getFallbackStorageDirectory(e);
    }
  }

  /// Get storage directory for iOS/macOS platforms
  Future<Directory> _getAppleStorageDirectory() async {
    // iOS/macOS: Use Application Support Directory
    // This persists across app updates and is backed up to iCloud
    return await getApplicationSupportDirectory();
  }

  /// Get storage directory for Android platforms with development-friendly approach
  Future<Directory> _getAndroidStorageDirectory() async {
    try {
      // Always try External Storage first for maximum development persistence
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        // Use app-specific subdirectory for better organisation
        return await _createAppSpecificDirectory(externalDir);
      }
    } catch (e) {
      debugPrint('External storage unavailable: $e');
    }

    // Fallback to Application Support Directory
    // This is safer for Android 14+ but less persistent during development
    return await getApplicationSupportDirectory();
  }

  /// Get storage directory for other platforms (Linux/Windows/etc.)
  Future<Directory> _getDefaultStorageDirectory() async {
    // Linux/Windows/Other: Use Application Support Directory
    return await getApplicationSupportDirectory();
  }

  /// Create app-specific subdirectory within the given base directory
  Future<Directory> _createAppSpecificDirectory(Directory baseDir) async {
    final appDir = Directory('${baseDir.path}/$_appDirectoryName');

    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }

    return appDir;
  }

  /// Create a subdirectory within the given base directory
  Future<Directory> _createSubdirectory(
    Directory baseDir,
    String subdirName,
  ) async {
    final subDir = Directory('${baseDir.path}/$subdirName');

    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }

    return subDir;
  }

  /// Fallback storage directory if all else fails
  Future<Directory> _getFallbackStorageDirectory(dynamic error) async {
    debugPrint('Failed to get persistent storage directory: $error');
    final documentsDir = await getApplicationDocumentsDirectory();
    return await _createSubdirectory(documentsDir, _appDirectoryName);
  }
}
