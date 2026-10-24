import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/styles/profile_styles.dart';

void main() {
  group('ProfileStyles', () {
    group('Layout Constants', () {
      test('provides consistent spacing values', () {
        expect(ProfileStyles.portraitSectionSpacing, equals(32.0));
        expect(ProfileStyles.landscapeSectionSpacing, equals(16.0));
        expect(ProfileStyles.sectionPadding, equals(20.0));
        expect(ProfileStyles.sectionBorderRadius, equals(16.0));
      });

      test('provides consistent header dimensions', () {
        expect(ProfileStyles.profileAvatarSize, equals(60.0));
        expect(ProfileStyles.profileAvatarSpacing, equals(16.0));
        expect(ProfileStyles.profileTitleFontSize, equals(24.0));
        expect(ProfileStyles.profileSubtitleFontSize, equals(14.0));
      });
    });

    group('Responsive Helpers', () {
      test('getChartHeight returns correct values', () {
        expect(ProfileStyles.getChartHeight(false), equals(350.0));
        expect(ProfileStyles.getChartHeight(true), equals(280.0));
      });

      test('getChartRadius returns correct values', () {
        expect(ProfileStyles.getChartRadius(false), equals(60.0));
        expect(ProfileStyles.getChartRadius(true), equals(50.0));
      });

      test('getEmptyStateHeight returns correct values', () {
        expect(ProfileStyles.getEmptyStateHeight(false), equals(250.0));
        expect(ProfileStyles.getEmptyStateHeight(true), equals(200.0));
      });

      test('getSubscriptionHeight returns correct values', () {
        expect(ProfileStyles.getSubscriptionHeight(false), equals(160.0));
        expect(ProfileStyles.getSubscriptionHeight(true), equals(100.0));
      });

      test('getSectionSpacing returns correct values', () {
        expect(ProfileStyles.getSectionSpacing(false), equals(32.0));
        expect(ProfileStyles.getSectionSpacing(true), equals(16.0));
      });
    });

    group('Typography', () {
      test('provides consistent text styles', () {
        final titleStyle = ProfileStyles.profileTitleStyle;
        expect(titleStyle.fontSize, equals(24.0));
        expect(titleStyle.fontWeight, equals(FontWeight.bold));

        final subtitleStyle = ProfileStyles.profileSubtitleStyle;
        expect(subtitleStyle.fontSize, equals(14.0));
      });

      test('provides responsive subscription styles', () {
        final portraitStyle = ProfileStyles.subscriptionComingSoonStyle(false);
        final landscapeStyle = ProfileStyles.subscriptionComingSoonStyle(true);

        expect(portraitStyle.fontSize, equals(24));
        expect(landscapeStyle.fontSize, equals(16));
        expect(portraitStyle.fontWeight, equals(FontWeight.bold));
        expect(landscapeStyle.fontWeight, equals(FontWeight.bold));
      });

      test('provides responsive game item styles', () {
        final portraitTitleStyle = ProfileStyles.gameItemTitleStyle(false);
        final landscapeTitleStyle = ProfileStyles.gameItemTitleStyle(true);

        expect(portraitTitleStyle.fontSize, equals(14));
        expect(landscapeTitleStyle.fontSize, equals(13));
        expect(portraitTitleStyle.fontWeight, equals(FontWeight.w600));
        expect(landscapeTitleStyle.fontWeight, equals(FontWeight.w600));
      });
    });

    group('Chart Colors', () {
      test('provides sufficient chart colors', () {
        expect(ProfileStyles.chartColors.length, greaterThanOrEqualTo(10));
        expect(
          ProfileStyles.chartColors.first,
          equals(const Color(0xFF8B5CF6)),
        );
      });
    });

    group('Decorations', () {
      test('provides consistent section decoration', () {
        final decoration = ProfileStyles.sectionDecoration;
        expect(decoration.borderRadius, isA<BorderRadius>());
        expect(decoration.gradient, isNotNull);
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.border, isNotNull);
      });

      test('provides game item decoration', () {
        final decoration = ProfileStyles.gameItemDecoration;
        expect(decoration.borderRadius, isA<BorderRadius>());
        expect(decoration.color, isNotNull);
        expect(decoration.border, isNotNull);
      });

      test('provides avatar decoration', () {
        final decoration = ProfileStyles.profileAvatarDecoration;
        expect(decoration.shape, equals(BoxShape.circle));
        expect(decoration.gradient, isNotNull);
      });
    });
  });
}
