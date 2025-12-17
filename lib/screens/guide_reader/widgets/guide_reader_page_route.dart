import 'package:flutter/material.dart';
import 'animations/guide_reader_transition.dart';

class GuideReaderPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  GuideReaderPageRoute({
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
    return GuideReaderTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}
