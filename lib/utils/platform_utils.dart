import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Utility class for platform-specific detection and behaviour
class PlatformUtils {
  /// Test override for platform detection - used in testing
  static bool? _testAndroid13Override;

  /// Check if the current platform is Android 13
  ///
  /// Android 13 introduced full screen text editing that lacks a "done" button
  /// This method helps identify when we need to provide additional UI controls
  static bool get isAndroid13 {
    // Allow test override
    if (_testAndroid13Override != null) return _testAndroid13Override!;

    if (!Platform.isAndroid) return false;

    // Android 13 is API level 33
    // We'll use a simple heuristic - if we can't determine the exact version,
    // we'll assume it might be Android 13 for safety
    return true; // For now, assume all Android devices might need this
  }

  /// Check if the current platform needs a "done" button for text input
  ///
  /// This is specifically for Android 13's full screen text editor issue
  static bool get needsTextInputDoneButton {
    return isAndroid13;
  }

  /// Override platform detection for testing purposes
  ///
  /// This allows tests to simulate Android 13 behaviour regardless of the host platform
  static void setTestAndroid13Override(bool? value) {
    _testAndroid13Override = value;
  }

  /// Returns true if the platform is iOS
  static bool isIOS() {
    return !kIsWeb && Platform.isIOS;
  }

  /// Returns true if the platform is Android (any version)
  static bool isAndroid() {
    return !kIsWeb && Platform.isAndroid;
  }

  /// Returns true if the platform is Android 14 or higher
  static Future<bool> isAndroid14OrHigher() async {
    if (!kIsWeb && Platform.isAndroid) {
      try {
        const platform = MethodChannel('com.example.chkpnt/platform');
        final apiLevel = await platform.invokeMethod<int>('getApiLevel');

        // Android 14 is API level 34+
        return apiLevel != null && apiLevel >= 34;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
