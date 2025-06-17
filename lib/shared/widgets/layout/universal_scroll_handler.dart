import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/styles.dart';

/// Universal widget that handles scroll-to-section functionality for any screen
///
/// This widget listens for scroll requests and animates scrolling to the
/// appropriate section when a new game is added. Works with any key type.
class UniversalScrollHandler extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;
  final Widget child;

  const UniversalScrollHandler({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
    required this.child,
  });

  @override
  ConsumerState<UniversalScrollHandler> createState() =>
      _UniversalScrollHandlerState();
}

class _UniversalScrollHandlerState
    extends ConsumerState<UniversalScrollHandler> {
  @override
  void initState() {
    super.initState();
    _setupScrollRequestListener();
  }

  void _setupScrollRequestListener() {
    ref.listenManual(scrollToSectionProvider, (previous, current) {
      if (current != null && previous != current) {
        _handleScrollRequest(current);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  // Business logic methods

  Future<void> _handleScrollRequest(ScrollRequest request) async {
    // Clear the request immediately to prevent duplicate handling
    ref.read(scrollToSectionProvider.notifier).clearRequest();

    // Add delay to allow UI to settle (section expansion, etc.)
    await Future.delayed(MainScreenStyles.scrollRequestDelay);

    // Find the target section and scroll to it
    await _scrollToSection(request.targetKey);
  }

  Future<void> _scrollToSection(String targetKey) async {
    // Try multiple times in case the key isn't available yet
    for (int attempt = 0; attempt < 3; attempt++) {
      final targetKey_ = widget.sectionKeys[targetKey];
      if (targetKey_?.currentContext != null) {
        final targetContext = targetKey_!.currentContext!;
        final targetRenderBox = targetContext.findRenderObject() as RenderBox?;
        if (targetRenderBox != null) {
          // Calculate the target scroll position
          final targetPosition = _calculateScrollPosition(targetRenderBox);

          // Animate to the target position
          await _animateToPosition(targetPosition);
          return; // Success!
        }
      }

      // Wait a bit before trying again
      if (attempt < 2) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  double _calculateScrollPosition(RenderBox targetRenderBox) {
    final targetOffset = targetRenderBox.localToGlobal(Offset.zero);
    final scrollOffset = widget.scrollController.offset;

    // Calculate the position in the scroll view
    final targetPositionInScroll = targetOffset.dy + scrollOffset;

    // Add extra offset from the top for better visual positioning
    final finalPosition =
        targetPositionInScroll - MainScreenStyles.scrollAnimationOffset;

    // Ensure we don't scroll beyond the available content
    final maxScrollExtent = widget.scrollController.position.maxScrollExtent;
    return finalPosition.clamp(0.0, maxScrollExtent);
  }

  Future<void> _animateToPosition(double targetPosition) async {
    if (!widget.scrollController.hasClients) return;

    await widget.scrollController.animateTo(
      targetPosition,
      duration: MainScreenStyles.scrollAnimationDuration,
      curve: MainScreenStyles.scrollAnimationCurve,
    );
  }
}
