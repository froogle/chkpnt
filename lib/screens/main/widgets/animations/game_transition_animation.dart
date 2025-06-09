import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/cards/game_card.dart';

class GameTransitionAnimation extends StatefulWidget {
  final GameItem game;
  final VoidCallback onComplete;

  const GameTransitionAnimation({
    super.key,
    required this.game,
    required this.onComplete,
  });

  @override
  State<GameTransitionAnimation> createState() =>
      _GameTransitionAnimationState();
}

class _GameTransitionAnimationState extends State<GameTransitionAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimation();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  Future<void> _startAnimation() async {
    await _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    widget.onComplete();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _animationController,
          builder:
              (context, child) => Stack(
                children: [
                  _buildMainAnimatedCard(context),
                  if (_slideAnimation.value > 0.2) ..._buildTrailEffects(),
                  if (_slideAnimation.value > 0.8) _buildSuccessIndicator(),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildMainAnimatedCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final startY = screenHeight * 0.6;
    final endY = screenHeight * 0.25;
    final currentY = startY - ((startY - endY) * _slideAnimation.value);

    return Positioned(
      left: 20,
      right: 20,
      top: currentY,
      child: Transform.scale(
        scale: 1.0 + (0.05 * _slideAnimation.value),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(
                  alpha: 0.4 * _slideAnimation.value,
                ),
                blurRadius: 20 * _slideAnimation.value,
                spreadRadius: 2 * _slideAnimation.value,
              ),
            ],
          ),
          child: GameCard(
            game: widget.game,
            layout: GameCardLayout.overlay,
            size: GameCardSize.medium,
            height: 120,
            onTap: () {},
            onPlayPressed: null,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTrailEffects() {
    final screenHeight = MediaQuery.of(context).size.height;
    final startY = screenHeight * 0.6;
    final endY = screenHeight * 0.25;

    return List.generate(3, (index) {
      final delay = 0.15 * index;
      final trailProgress = (_slideAnimation.value - delay).clamp(0.0, 1.0);
      final trailY = startY - ((startY - endY) * trailProgress * 0.8);

      return Positioned(
        left: 20,
        right: 20,
        top: trailY,
        child: Opacity(
          opacity:
              (0.3 - (0.1 * index)) *
              trailProgress *
              (1 - _slideAnimation.value),
          child: Transform.scale(
            scale: 0.95 - (0.05 * index),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.orange.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSuccessIndicator() {
    final screenHeight = MediaQuery.of(context).size.height;
    final endY = screenHeight * 0.25;

    return Positioned(
      left: 20,
      right: 20,
      top: endY - 10,
      child: Opacity(
        opacity: (_slideAnimation.value - 0.8) * 5,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: RadialGradient(
              colors: [Colors.green.withValues(alpha: 0.2), Colors.transparent],
              radius: 1.5,
            ),
          ),
          child: const Center(
            child: Icon(Icons.play_circle_fill, color: Colors.green, size: 48),
          ),
        ),
      ),
    );
  }
}
