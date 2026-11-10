import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class CollapsibleSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget content;
  final bool isEmpty;
  final Widget? emptyStateWidget;

  const CollapsibleSection({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.content,
    this.isEmpty = false,
    this.emptyStateWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MainScreenStyles.collapsibleSectionMargin,
      decoration: MainScreenStyles.collapsibleSectionDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), if (isExpanded) _buildContent()],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: _buildHeaderDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Clear focus from any text fields before handling the tap
            FocusManager.instance.primaryFocus?.unfocus();
            onToggle();
          },
          child: Padding(
            padding: MainScreenStyles.collapsibleSectionHeaderPadding,
            child: _buildHeaderContent(),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildHeaderDecoration() {
    return isExpanded
        ? MainScreenStyles.collapsibleSectionHeaderDecoration
        : MainScreenStyles.collapsibleSectionHeaderDecoration.copyWith(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          );
  }

  Widget _buildHeaderContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: MainScreenStyles.sectionHeaderStyle),
        Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: MainScreenStyles.expandIconColor,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Container(
      padding: MainScreenStyles.collapsibleSectionContentPadding,
      decoration: const BoxDecoration(
        color: MainScreenStyles.collapsibleSectionColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: isEmpty && emptyStateWidget != null ? emptyStateWidget! : content,
    );
  }
}
