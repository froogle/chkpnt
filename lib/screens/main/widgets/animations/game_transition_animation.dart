import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';

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
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimation();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _startAnimation() async {
    // Small delay to ensure the game has faded out from backlog
    await Future.delayed(const Duration(milliseconds: 200));

    // Start the fade-in animation
    await _fadeController.forward();

    // Small delay before completing
    await Future.delayed(const Duration(milliseconds: 100));
    widget.onComplete();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This animation now just provides timing - the actual visual effect
    // is handled by the Playing section showing the game with a fade-in
    return const SizedBox.shrink();
  }
}
