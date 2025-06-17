import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/utils/platform_utils.dart';

void main() {
  group('PlatformUtils.abbreviatePlatformName', () {
    group('Nintendo platforms', () {
      test('abbreviates Game Boy platforms correctly', () {
        expect(PlatformUtils.abbreviatePlatformName('Game Boy Advance'), 'GBA');
        expect(PlatformUtils.abbreviatePlatformName('gameboy advance'), 'GBA');
        expect(PlatformUtils.abbreviatePlatformName('Game Boy Color'), 'GBC');
        expect(PlatformUtils.abbreviatePlatformName('gameboy color'), 'GBC');
        expect(PlatformUtils.abbreviatePlatformName('Game Boy'), 'GB');
        expect(PlatformUtils.abbreviatePlatformName('gameboy'), 'GB');
      });

      test('abbreviates Nintendo console platforms correctly', () {
        expect(
          PlatformUtils.abbreviatePlatformName('Nintendo Switch'),
          'Switch',
        );
        expect(PlatformUtils.abbreviatePlatformName('Nintendo 3DS'), '3DS');
        expect(PlatformUtils.abbreviatePlatformName('Nintendo DS'), 'DS');
        expect(PlatformUtils.abbreviatePlatformName('Nintendo 64'), 'N64');
        expect(
          PlatformUtils.abbreviatePlatformName('Nintendo GameCube'),
          'GameCube',
        );
        expect(PlatformUtils.abbreviatePlatformName('gamecube'), 'GameCube');
        expect(PlatformUtils.abbreviatePlatformName('Nintendo Wii'), 'Wii');
        expect(PlatformUtils.abbreviatePlatformName('Nintendo Wii U'), 'Wii U');
      });

      test('abbreviates Nintendo retro platforms correctly', () {
        expect(
          PlatformUtils.abbreviatePlatformName('Nintendo Entertainment System'),
          'NES',
        );
        expect(PlatformUtils.abbreviatePlatformName('nes'), 'NES');
        expect(PlatformUtils.abbreviatePlatformName('Super Nintendo'), 'SNES');
        expect(
          PlatformUtils.abbreviatePlatformName(
            'Super Nintendo Entertainment System',
          ),
          'SNES',
        );
        expect(PlatformUtils.abbreviatePlatformName('snes'), 'SNES');
      });
    });

    group('PlayStation platforms', () {
      test('abbreviates PlayStation consoles correctly', () {
        expect(PlatformUtils.abbreviatePlatformName('PlayStation'), 'PS1');
        expect(PlatformUtils.abbreviatePlatformName('PlayStation 1'), 'PS1');
        expect(PlatformUtils.abbreviatePlatformName('PlayStation 2'), 'PS2');
        expect(PlatformUtils.abbreviatePlatformName('PlayStation 3'), 'PS3');
        expect(PlatformUtils.abbreviatePlatformName('PlayStation 4'), 'PS4');
        expect(PlatformUtils.abbreviatePlatformName('PlayStation 5'), 'PS5');
      });

      test('abbreviates PlayStation handhelds correctly', () {
        expect(
          PlatformUtils.abbreviatePlatformName('PlayStation Portable'),
          'PSP',
        );
        expect(
          PlatformUtils.abbreviatePlatformName('PlayStation Vita'),
          'PS Vita',
        );
      });
    });

    group('Xbox platforms', () {
      test('abbreviates Xbox consoles correctly', () {
        expect(PlatformUtils.abbreviatePlatformName('Xbox'), 'Xbox');
        expect(PlatformUtils.abbreviatePlatformName('Original Xbox'), 'Xbox');
        expect(PlatformUtils.abbreviatePlatformName('Xbox 360'), 'Xbox 360');
        expect(PlatformUtils.abbreviatePlatformName('Xbox One'), 'Xbox One');
        expect(
          PlatformUtils.abbreviatePlatformName('Xbox Series X'),
          'Xbox Series',
        );
        expect(
          PlatformUtils.abbreviatePlatformName('Xbox Series S'),
          'Xbox Series',
        );
        expect(
          PlatformUtils.abbreviatePlatformName('Xbox Series X/S'),
          'Xbox Series',
        );
      });
    });

    group('PC and other platforms', () {
      test('abbreviates PC platforms correctly', () {
        expect(PlatformUtils.abbreviatePlatformName('Personal Computer'), 'PC');
        expect(
          PlatformUtils.abbreviatePlatformName('Steam Deck'),
          'Steam Deck',
        );
      });

      test('keeps mobile platforms as-is', () {
        expect(PlatformUtils.abbreviatePlatformName('mobile'), 'mobile');
        expect(PlatformUtils.abbreviatePlatformName('iOS'), 'iOS');
        expect(PlatformUtils.abbreviatePlatformName('Android'), 'Android');
      });
    });

    group('edge cases', () {
      test('handles empty and whitespace strings', () {
        expect(PlatformUtils.abbreviatePlatformName(''), '');
        expect(PlatformUtils.abbreviatePlatformName('   '), '');
        expect(PlatformUtils.abbreviatePlatformName('\t\n'), '');
      });

      test('trims whitespace from input', () {
        expect(
          PlatformUtils.abbreviatePlatformName('  PlayStation 4  '),
          'PS4',
        );
        expect(
          PlatformUtils.abbreviatePlatformName('\tNintendo Switch\n'),
          'Switch',
        );
      });

      test('handles unknown platforms', () {
        expect(
          PlatformUtils.abbreviatePlatformName('Custom Platform'),
          'Custom Platf...',
        );
        expect(
          PlatformUtils.abbreviatePlatformName('My Game System'),
          'My Game Syst...',
        );
      });

      test('truncates very long unknown platform names', () {
        const longPlatform = 'Super Ultra Mega Gaming System Pro Max';
        final result = PlatformUtils.abbreviatePlatformName(longPlatform);
        expect(
          result,
          'Super Ultra ...',
        ); // Should be truncated to 12 chars + ...
        expect(result.length, 15); // 12 chars + '...'
      });

      test('preserves reasonable length unknown platforms', () {
        expect(PlatformUtils.abbreviatePlatformName('Dreamcast'), 'Dreamcast');
        expect(
          PlatformUtils.abbreviatePlatformName('Atari 2600'),
          'Atari 2600',
        );
      });
    });

    group('case insensitive matching', () {
      test('handles mixed case input', () {
        expect(
          PlatformUtils.abbreviatePlatformName('NINTENDO SWITCH'),
          'Switch',
        );
        expect(PlatformUtils.abbreviatePlatformName('playstation 4'), 'PS4');
        expect(PlatformUtils.abbreviatePlatformName('XbOx OnE'), 'Xbox One');
      });
    });
  });
}
