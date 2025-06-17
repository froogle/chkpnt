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
  /// Stores pending scroll intent when keys aren't available yet
  String? _pendingScrollIntent;

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
  void didUpdateWidget(UniversalScrollHandler oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if we have a pending scroll intent and keys have become available
    if (_pendingScrollIntent != null &&
        widget.sectionKeys.containsKey(_pendingScrollIntent) &&
        widget.sectionKeys[_pendingScrollIntent]?.currentContext != null) {
      // Keys are now available, attempt the scroll
      final targetKey = _pendingScrollIntent!;
      _pendingScrollIntent = null; // Clear the intent

      // Schedule the scroll attempt for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _attemptScrollToSection(targetKey);
      });
    }
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

    // Attempt to scroll immediately
    final success = await _attemptScrollToSection(request.targetKey);

    // If unsuccessful, register the intent for when keys become available
    if (!success) {
      _pendingScrollIntent = request.targetKey;
    }
  }

  /// Attempts to scroll to a section, returns true if successful
  Future<bool> _attemptScrollToSection(String targetKey) async {
    final targetKey_ = widget.sectionKeys[targetKey];
    if (targetKey_?.currentContext != null) {
      final targetContext = targetKey_!.currentContext!;
      final targetRenderBox = targetContext.findRenderObject() as RenderBox?;
      if (targetRenderBox != null) {
        // Calculate the target scroll position
        final targetPosition = _calculateScrollPosition(targetRenderBox);

        // Animate to the target position
        await _animateToPosition(targetPosition);
        return true; // Success!
      }
    }
    return false; // Failed to scroll
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
