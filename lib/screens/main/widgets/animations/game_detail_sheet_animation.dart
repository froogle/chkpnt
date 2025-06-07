import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../models/game_models.dart';
import '../../../../styles/styles.dart';
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
      transitionAnimationController: _createAnimationController(context),
      builder:
          (context) =>
              _GameDetailSheetWrapper(game: game, onEditPressed: onEditPressed),
    );
  }

  static AnimationController _createAnimationController(BuildContext context) {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 250),
      vsync: Navigator.of(context),
    );
  }
}

class _GameDetailSheetWrapper extends StatefulWidget {
  final GameItem game;
  final VoidCallback? onEditPressed;

  const _GameDetailSheetWrapper({required this.game, this.onEditPressed});

  @override
  State<_GameDetailSheetWrapper> createState() =>
      _GameDetailSheetWrapperState();
}

class _GameDetailSheetWrapperState extends State<_GameDetailSheetWrapper>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _blurController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _blurController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _blurAnimation = Tween<double>(
      begin: 0.0,
      end: 5.0,
    ).animate(CurvedAnimation(parent: _blurController, curve: Curves.easeOut));
  }

  void _startAnimations() {
    _blurController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideAnimation, _blurAnimation]),
      builder: (context, child) => _buildAnimationContent(),
    );
  }

  Widget _buildAnimationContent() {
    return Stack(children: [_buildBlurredBackground(), _buildAnimatedSheet()]);
  }

  Widget _buildBlurredBackground() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _blurAnimation.value,
          sigmaY: _blurAnimation.value,
        ),
        child: Container(color: Colors.black.withValues(alpha: 0.1)),
      ),
    );
  }

  Widget _buildAnimatedSheet() {
    return SlideTransition(
      position: _slideAnimation,
      child: LayoutBuilder(
        builder: (context, constraints) => _buildResponsiveSheet(),
      ),
    );
  }

  Widget _buildResponsiveSheet() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return DraggableScrollableSheet(
      initialChildSize: isLandscape ? 0.85 : 0.75,
      minChildSize: isLandscape ? 0.6 : 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => _buildSheetContainer(),
    );
  }

  Widget _buildSheetContainer() {
    return Container(
      decoration: GameDetailSheetStyles.sheetDecoration,
      child: GameDetailSheet(
        game: widget.game,
        onEditPressed: widget.onEditPressed,
      ),
    );
  }
}

// Extension for easy access
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
