import 'package:flutter/material.dart';
import 'package:medigaze/core/app_export.dart';

import 'package:medigaze/theme/theme_helper.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray50,
      );
  static BoxDecoration get fillBluegray10002 => BoxDecoration(
        color: appTheme.blueGray10002.withOpacity(0.7),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray5001,
      );
  static BoxDecoration get fillOnError => BoxDecoration(
        color: theme.colorScheme.onError,
      );

  // Gradient decorations
  static BoxDecoration get gradientAmberToErrorContainer => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.amber300,
            theme.colorScheme.errorContainer,
          ],
        ),
      );
  static BoxDecoration get gradientOnErrorToGray => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            theme.colorScheme.onError,
            appTheme.gray5001,
          ],
        ),
      );
  static BoxDecoration get gradientOnPrimaryContainerToOnError => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.53, -0.56),
          end: Alignment(2.86, 3.19),
          colors: [
            theme.colorScheme.onPrimaryContainer,
            appTheme.orangeA100,
            theme.colorScheme.onError,
          ],
        ),
      );

      static BoxDecoration get outlineGray => BoxDecoration(
        color: theme.colorScheme.onError.withOpacity(1),
        border: Border.all(
          color: appTheme.gray900,
          width: 1.h,
        ),
      );
  static BoxDecoration get gradientOrangeAToErrorContainer => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1, 0.91),
          end: Alignment(0.02, 0.07),
          colors: [
            appTheme.orangeA100,
            theme.colorScheme.errorContainer,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineBlueGray => BoxDecoration(
        color: theme.colorScheme.onError,
        border: Border.all(
          color: appTheme.blueGray10002.withOpacity(0.9),
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBluegray10001 => BoxDecoration(
        border: Border(
          left: BorderSide(
            color: appTheme.blueGray10001,
            width: 1.h,
          ),
          right: BorderSide(
            color: appTheme.blueGray10001,
            width: 1.h,
          ),
        ),
      );
  static BoxDecoration get outlineErrorContainer => BoxDecoration(
        color: theme.colorScheme.onError,
        border: Border.all(
          color: theme.colorScheme.errorContainer,
          width: 1.h,
        ),
      );
      static BoxDecoration get outlineBlueGrayE => BoxDecoration(
        color: theme.colorScheme.onErrorContainer,
        border: Border.all(
          color: appTheme.blueGray10001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimary => BoxDecoration(
        color: theme.colorScheme.onError,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      );

       // Outline decorations
  static BoxDecoration get outlineAmber => BoxDecoration(
        color: theme.colorScheme.onErrorContainer,
        boxShadow: [
          BoxShadow(
            color: appTheme.amber300.withOpacity(0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlinePrimary1 => BoxDecoration(
        color: theme.colorScheme.onError,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              1.15,
            ),
          ),
        ],
      );
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderBL10 => BorderRadius.vertical(
        bottom: Radius.circular(10.h),
      );
  static BorderRadius get customBorderBL20 => BorderRadius.vertical(
        bottom: Radius.circular(20.h),
      );
    static BorderRadius get roundedBorder20 => BorderRadius.circular(
    20.h,
  );

  // Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
  static BorderRadius get roundedBorder32 => BorderRadius.circular(
        32.h,
      );
  static BorderRadius get roundedBorder7 => BorderRadius.circular(
        7.h,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
