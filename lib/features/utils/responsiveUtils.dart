import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
///  with also the web compatibility
class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1200;

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint &&
        MediaQuery.of(context).size.width < tabletBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Get responsive padding based on screen size
  ///TODO need to be eddited after testing
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64.0);
    }
  }

  /// Get responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 2;
    } else if (width < tabletBreakpoint) {
      return 3;
    } else if (width < 1400) {
      return 4;
    } else {
      return 5; // For very large screens
    }
  }

  /// Get responsive grid child aspect ratio with better web proportions
  static double getGridChildAspectRatio(BuildContext context) {
    if (isMobile(context)) {
      return 0.85; // Slightly taller cards for mobile
    } else if (isTablet(context)) {
      return 0.88;
    } else {
      return 0.9; // Better proportions for desktop
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
      BuildContext context, double baseFontSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return baseFontSize;
    } else if (width < tabletBreakpoint) {
      return baseFontSize * 1.1;
    } else if (width < 1400) {
      return baseFontSize * 1.2;
    } else {
      return baseFontSize * 1.3; // For very large screens
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isMobile(context)) {
      return baseSpacing;
    } else if (isTablet(context)) {
      return baseSpacing * 1.2;
    } else {
      return baseSpacing * 1.4;
    }
  }

  /// Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    if (isMobile(context)) {
      return 60;
    } else if (isTablet(context)) {
      return 70;
    } else {
      return 80;
    }
  }

  /// Get responsive container constraints - Fixed for web
  static BoxConstraints getResponsiveConstraints(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return const BoxConstraints(maxWidth: double.infinity);
    } else if (width < tabletBreakpoint) {
      return const BoxConstraints(maxWidth: 900);
    } else if (width < 1600) {
      return const BoxConstraints(maxWidth: 1200);
    } else {
      return const BoxConstraints(maxWidth: 1400); // For very large screens
    }
  }

  /// Get responsive layout padding for centering content on larger screens
  static EdgeInsets getResponsiveLayoutPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
        vertical: 20.0,
      );
    } else {
      return EdgeInsets.symmetric(
        horizontal: screenWidth * 0.12,
        vertical: 24.0,
      );
    }
  }

  /// Get responsive brand filter button size
  static EdgeInsets getBrandFilterPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(vertical: 8, horizontal: 12);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(vertical: 10, horizontal: 16);
    } else {
      return const EdgeInsets.symmetric(vertical: 12, horizontal: 20);
    }
  }

  /// Get responsive avatar radius
  static double getAvatarRadius(BuildContext context) {
    if (isMobile(context)) {
      return 22;
    } else if (isTablet(context)) {
      return 26;
    } else {
      return 30;
    }
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.15;
    } else {
      return baseSize * 1.3;
    }
  }

  /// Get responsive card elevation
  static double getCardElevation(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Get responsive border radius
  static double getBorderRadius(BuildContext context,
      {double baseRadius = 12}) {
    if (isMobile(context)) {
      return baseRadius;
    } else if (isTablet(context)) {
      return baseRadius * 1.1;
    } else {
      return baseRadius * 1.2;
    }
  }

  /// Get responsive card image height
  static double getCardImageHeight(BuildContext context) {
    if (isMobile(context)) {
      return 100;
    } else if (isTablet(context)) {
      return 120;
    } else {
      return 140;
    }
  }

  /// Get responsive grid spacing
  static double getGridSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 8;
    } else if (isTablet(context)) {
      return 12;
    } else {
      return 16;
    }
  }

  /// Get responsive content width for centering
  static double getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < mobileBreakpoint) {
      return screenWidth;
    } else if (screenWidth < tabletBreakpoint) {
      return 900;
    } else if (screenWidth < 1600) {
      return 1200;
    } else {
      return 1400;
    }
  }

  /// Check if we're on web platform
  static bool isWeb() {
    return identical(0, 0.0); // Simple web detection
  }

  /// Get safe area padding for web
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    if (isWeb()) {
      return const EdgeInsets.all(0);
    }
    return MediaQuery.of(context).padding;
  }
}
