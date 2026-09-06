import 'dart:io';
import 'package:flutter/foundation.dart';

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

    // Disabled - let Android handle all input natively
    return false;
  }

  /// Check if the current platform needs a "done" button for text input
  ///
  /// This is specifically for Android 13's full screen text editor issue
  static bool get needsTextInputDoneButton {
    return false; // Disabled - let Android handle input natively
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

  static const int _shortestUnambiguousTerm = 3;

  static final List<MapEntry<String, String>> _detectionTerms =
      _buildDetectionTerms();

  static List<MapEntry<String, String>> _buildDetectionTerms() {
    final terms = <String, String>{};
    _platformAbbreviations.forEach((name, abbreviation) {
      terms[name] = abbreviation;
      terms[abbreviation.toLowerCase()] = abbreviation;
    });

    final entries = terms.entries.toList();
    entries.sort((a, b) => b.key.length.compareTo(a.key.length));
    return entries;
  }

  static PlatformMatch? findPlatform(String text) {
    final haystack = text.toLowerCase();

    for (final term in _detectionTerms) {
      final matches = RegExp(
        '(?<![a-z0-9])${RegExp.escape(term.key)}(?![a-z0-9])',
      ).allMatches(haystack);

      for (final match in matches.toList().reversed) {
        if (term.key.length >= _shortestUnambiguousTerm ||
            _hasEnoughContext(haystack, match)) {
          return PlatformMatch(
            abbreviation: term.value,
            start: match.start,
            end: match.end,
          );
        }
      }
    }

    return null;
  }

  static bool _hasEnoughContext(String haystack, Match match) {
    const openingBrackets = {'(', '['};
    const closingBrackets = {')', ']'};

    final before = match.start == 0 ? '' : haystack[match.start - 1];
    final after =
        match.end == haystack.length ? '' : haystack[match.end];

    final isBracketed =
        openingBrackets.contains(before) && closingBrackets.contains(after);
    final isWholeString = haystack.trim() == haystack.substring(
      match.start,
      match.end,
    );
    final isStringFinal = match.end == haystack.trimRight().length;

    return isBracketed || isWholeString || isStringFinal;
  }

  static String? detectPlatform(String text) => findPlatform(text)?.abbreviation;

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

class PlatformMatch {
  final String abbreviation;
  final int start;
  final int end;

  const PlatformMatch({
    required this.abbreviation,
    required this.start,
    required this.end,
  });
}
