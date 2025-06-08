import 'package:flutter/material.dart';

/// Custom transition animation for the edit screen
///
/// Provides a smooth slide-up transition from detail to edit view,
/// with the detail screen sliding up and out while the edit screen
/// slides in from the bottom.
class EditScreenTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const EditScreenTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0), // Start from bottom
        end: Offset.zero, // End at current position
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero, // Detail screen starts at current position
          end: const Offset(0.0, -1.0), // Slides up and out
        ).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeInOutCubic,
          ),
        ),
        child: child,
      ),
    );
  }
}
