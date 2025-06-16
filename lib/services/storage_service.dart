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

  /// Get the most persistent storage directory for each platform using a hybrid approach
  ///
  /// This hybrid strategy balances data persistence with Android 14+ compatibility:
  /// - iOS/macOS: Uses Application Support Directory (persists across updates, backed up to iCloud)
  /// - Android 14+: Uses Application Support Directory (avoids scoped storage permission issues)
  /// - Android 13 and below: Uses External Storage with app subfolder (persists across dev rebuilds and uninstalls)
  /// - Other platforms: Falls back to Application Support Directory
  Future<Directory> getPersistentStorageDirectory() async {
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

  /// Get storage directory for iOS/macOS platforms
  Future<Directory> _getAppleStorageDirectory() async {
    // iOS/macOS: Use Application Support Directory
    // This persists across app updates and is backed up to iCloud
    return await getApplicationSupportDirectory();
  }

  /// Get storage directory for Android platforms based on version
  Future<Directory> _getAndroidStorageDirectory() async {
    final isAndroid14OrLater = await this.isAndroid14OrLater();

    if (isAndroid14OrLater) {
      return await _getAndroid14StorageDirectory();
    }

    return await _getAndroid13StorageDirectory();
  }

  /// Get storage directory for Android 14+ (uses Application Support)
  Future<Directory> _getAndroid14StorageDirectory() async {
    // Android 14+: Use Application Support Directory to avoid scoped storage issues
    // Data persists through app updates but not development rebuilds
    return await getApplicationSupportDirectory();
  }

  /// Get storage directory for Android 13 and below (uses External Storage)
  Future<Directory> _getAndroid13StorageDirectory() async {
    // Android 13 and below: Use External Storage Directory for maximum persistence
    // This persists across app updates, uninstalls, and development rebuilds
    final externalDir = await getExternalStorageDirectory();

    if (externalDir == null) {
      // Fallback to Application Support Directory if external storage unavailable
      return await getApplicationSupportDirectory();
    }

    return await _createAppSpecificDirectory(externalDir);
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

  /// Fallback storage directory if all else fails
  Future<Directory> _getFallbackStorageDirectory(dynamic error) async {
    debugPrint('Failed to get persistent storage directory: $error');
    return await getApplicationDocumentsDirectory();
  }
}
