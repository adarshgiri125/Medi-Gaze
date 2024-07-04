import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeErrorContainer => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get bodyLargeBluegray700 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray700,
      );
  static get titleLargeGray700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray700,
        fontWeight: FontWeight.w400,
      );
  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get bodyLargeOpenSansGray700 =>
      theme.textTheme.bodyLarge!.openSans.copyWith(
        color: appTheme.gray700,
      );
  static get titleMediumBlack900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );

  static get bodyMediumOnSecondaryContainer =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
      );
  static get bodyLargeGray700 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray700,
      );
  static get bodyLargeInterBluegray500 =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: appTheme.blueGray500,
      );
  static get bodyLargeInterBluegray700 =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: appTheme.blueGray700,
      );
  static get bodyLargeInterBluegray700_1 =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: appTheme.blueGray700,
      );
  static get bodyMediumGray40002 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray40002,
      );
  static get bodyMediumGray50 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray50,
      );
  static get bodyMediumGray700 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray700,
      );
  static get bodyMediumGray700_1 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray700,
      );
  static get bodyMediumInterBluegray700 =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        color: appTheme.blueGray700,
      );
  static get bodyMediumOtomanopeeOne =>
      theme.textTheme.bodyMedium!.otomanopeeOne;
  static get bodyMediumOtomanopeeOneOnPrimary =>
      theme.textTheme.bodyMedium!.otomanopeeOne.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get bodyMediumOtomanopeeOne_1 =>
      theme.textTheme.bodyMedium!.otomanopeeOne;
  static get bodySmallAvenirNextLTProPrimary =>
      theme.textTheme.bodySmall!.avenirNextLTPro.copyWith(
        color: theme.colorScheme.primary.withOpacity(1),
      );
  static get bodySmallInterBluegray700 =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.blueGray700,
        fontSize: 12.fSize,
      );
  // Title text style
  static get titleLargeBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleLargeBold_1 => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleLargeRegular => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w400,
      );
  static get titleLargeRegular_1 => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w400,
      );
  static get titleMediumInterBluegray700 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.blueGray700,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumInterGray800 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallBluegray700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray700,
      );
  static get titleSmallBluegray800 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray800,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallOpenSansOnError =>
      theme.textTheme.titleSmall!.openSans.copyWith(
        color: theme.colorScheme.onError,
        fontWeight: FontWeight.w700,
      );
}

extension on TextStyle {
  TextStyle get sFProText {
    return copyWith(
      fontFamily: 'SF Pro Text',
    );
  }

  TextStyle get openSans {
    return copyWith(
      fontFamily: 'Open Sans',
    );
  }

  TextStyle get avenirNextLTPro {
    return copyWith(
      fontFamily: 'Avenir Next LT Pro',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get otomanopeeOne {
    return copyWith(
      fontFamily: 'Otomanopee One',
    );
  }
}
