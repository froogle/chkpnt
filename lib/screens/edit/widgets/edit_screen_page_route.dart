import 'package:flutter/material.dart';
import 'animations/edit_screen_transition.dart';

/// Custom page route for the edit screen with slide animation
///
/// Provides a smooth slide-up transition from detail to edit view,
/// with proper hero animations for shared elements like the game image.
class EditScreenPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  EditScreenPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    super.settings,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
       );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return EditScreenTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}
