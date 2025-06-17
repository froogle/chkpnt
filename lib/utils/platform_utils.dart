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

  /// Platform name abbreviation mapping
  static const Map<String, String> _platformAbbreviations = {
    // Game Boy family
    'game boy advance': 'GBA',
    'gameboy advance': 'GBA',
    'game boy color': 'GBC',
    'gameboy color': 'GBC',
    'game boy': 'GB',
    'gameboy': 'GB',

    // Nintendo consoles
    'nintendo switch': 'Switch',
    'nintendo 3ds': '3DS',
    'nintendo ds': 'DS',
    'nintendo entertainment system': 'NES',
    'nes': 'NES',
    'super nintendo': 'SNES',
    'super nintendo entertainment system': 'SNES',
    'snes': 'SNES',
    'nintendo 64': 'N64',
    'nintendo gamecube': 'GameCube',
    'gamecube': 'GameCube',
    'nintendo wii': 'Wii',
    'nintendo wii u': 'Wii U',

    // PlayStation family
    'playstation': 'PS1',
    'playstation 1': 'PS1',
    'playstation 2': 'PS2',
    'playstation 3': 'PS3',
    'playstation 4': 'PS4',
    'playstation 5': 'PS5',
    'playstation portable': 'PSP',
    'playstation vita': 'PS Vita',

    // Xbox family
    'xbox': 'Xbox',
    'original xbox': 'Xbox',
    'xbox 360': 'Xbox 360',
    'xbox one': 'Xbox One',
    'xbox series x': 'Xbox Series',
    'xbox series s': 'Xbox Series',
    'xbox series x/s': 'Xbox Series',

    // PC and mobile
    'steam deck': 'Steam Deck',
    'personal computer': 'PC',
  };

  /// Platforms that should be kept as-is (mobile platforms)
  static const Set<String> _preservedPlatforms = {'mobile', 'ios', 'android'};

  /// Abbreviates platform names to standardised short forms
  ///
  /// Takes a platform name and returns an abbreviated version suitable for display.
  /// This helps maintain consistency across the app and reduces clutter in the UI.
  static String abbreviatePlatformName(String platform) {
    final normalised = platform.trim().toLowerCase();

    // Check if it's a preserved platform (mobile platforms)
    if (_preservedPlatforms.contains(normalised)) {
      return platform.trim(); // Return with original casing
    }

    // Look up abbreviation
    final abbreviation = _platformAbbreviations[normalised];
    if (abbreviation != null) {
      return abbreviation;
    }

    // For unknown platforms, keep original if reasonable length
    // or truncate if too long
    final trimmed = platform.trim();
    return trimmed.length > 12 ? '${trimmed.substring(0, 12)}...' : trimmed;
  }
}
