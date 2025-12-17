import 'package:flutter/material.dart';
import 'package:chkpnt/styles/layout_styles.dart';

class UIUtils {
  static SliverGridDelegateWithMaxCrossAxisExtent getResponsiveGridDelegate() {
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: ResponsiveGridConfig.targetCardWidth,
      mainAxisSpacing: ResponsiveGridConfig.gridSpacing,
      crossAxisSpacing: ResponsiveGridConfig.gridSpacing,
      childAspectRatio: ResponsiveGridConfig.childAspectRatio,
    );
  }
}
