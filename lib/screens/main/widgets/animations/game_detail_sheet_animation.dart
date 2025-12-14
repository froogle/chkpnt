import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import '../game_detail_sheet.dart';

class GameDetailSheetAnimation {
  static Future<void> show(
    BuildContext context,
    GameItem game, {
    VoidCallback? onEditPressed,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 250),
        vsync: Navigator.of(context),
      ),
      builder: (context) => _GameDetailSheetContent(
        game: game,
        onEditPressed: onEditPressed,
      ),
    );
  }
}

class _GameDetailSheetContent extends StatelessWidget {
  final GameItem game;
  final VoidCallback? onEditPressed;

  const _GameDetailSheetContent({required this.game, this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: DraggableScrollableSheet(
        initialChildSize: isLandscape ? 0.85 : 0.75,
        minChildSize: isLandscape ? 0.6 : 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => GestureDetector(
          onTap: () {},
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xB3FFFFFF), Colors.white],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: GameDetailSheet(
                game: game,
                onEditPressed: onEditPressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension GameDetailSheetShowExtension on GameItem {
  Future<void> showDetailSheet(
    BuildContext context, {
    VoidCallback? onEditPressed,
  }) {
    return GameDetailSheetAnimation.show(
      context,
      this,
      onEditPressed: onEditPressed,
    );
  }
}
