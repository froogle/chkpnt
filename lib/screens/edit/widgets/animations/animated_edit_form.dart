import 'package:flutter/material.dart';

/// Animated form wrapper that provides staggered fade-in animations
/// for edit form elements to create a polished user experience.
class AnimatedEditForm extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration staggerDuration;

  const AnimatedEditForm({
    super.key,
    required this.children,
    this.delay = const Duration(milliseconds: 100),
    this.staggerDuration = const Duration(milliseconds: 80),
  });

  @override
  State<AnimatedEditForm> createState() => _AnimatedEditFormState();
}

class _AnimatedEditFormState extends State<AnimatedEditForm>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations =
        _controllers.map((controller) {
          return CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutCubic,
          );
        }).toList();
  }

  void _startAnimations() async {
    if (!mounted) return;

    await Future.delayed(widget.delay);
    if (!mounted) return;

    for (int i = 0; i < _controllers.length; i++) {
      if (!mounted) return;
      _controllers[i].forward();
      if (i < _controllers.length - 1) {
        await Future.delayed(widget.staggerDuration);
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          widget.children.asMap().entries.map((entry) {
            final index = entry.key;
            final child = entry.value;

            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animations[index],
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_animations[index]),
                    child: child,
                  ),
                );
              },
              child: child,
            );
          }).toList(),
    );
  }
}
