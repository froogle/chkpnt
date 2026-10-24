import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/styles/status_styles.dart';

void main() {
  group('StatusStyles', () {
    test('presents every Status with one label, icon and colour', () {
      final expected = {
        GameStatus.playing: ('Playing', Icons.play_circle_fill, Colors.orange),
        GameStatus.completed: ('Completed', Icons.check_circle, Colors.green),
        GameStatus.backlog: ('Backlog', Icons.schedule, Colors.blue),
        GameStatus.abandoned: (
          'Abandoned',
          Icons.do_not_disturb_on,
          Colors.grey,
        ),
        GameStatus.wishlist: ('Wishlist', Icons.favorite, Colors.pink),
        GameStatus.ordered: ('Ordered', Icons.shopping_cart, Colors.purple),
        GameStatus.ongoing: ('Ongoing', Icons.replay, const Color(0xFF06B6D4)),
      };

      for (final entry in expected.entries) {
        final (label, icon, colour) = entry.value;
        final style = StatusStyles.of(entry.key);

        expect(style.label, label, reason: '${entry.key} label');
        expect(style.icon, icon, reason: '${entry.key} icon');
        expect(style.colour, colour, reason: '${entry.key} colour');
      }
    });

    test(
      'presents a Game with no Status as in the Collection, without an icon',
      () {
        final style = StatusStyles.of(GameStatus.owned);

        expect(style.label, 'In Collection');
        expect(style.icon, isNull);
        expect(style.colour, AppColors.emptyStateIcon);
      },
    );

    test('gives every Status a distinct colour', () {
      final colours = GameStatus.values.map((s) => StatusStyles.of(s).colour);

      expect(colours.toSet().length, GameStatus.values.length);
    });
  });
}
