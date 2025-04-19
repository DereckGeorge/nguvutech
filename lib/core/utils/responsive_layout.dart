import 'package:flutter/material.dart';

/// Breakpoints for responsive layouts
class ScreenSize {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;
}

/// Helper class to determine device screen type
class DeviceScreenType {
  /// Returns true if the device is a mobile device (width < 600)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ScreenSize.mobileBreakpoint;
  }

  /// Returns true if the device is a tablet (600 <= width < 1200)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ScreenSize.mobileBreakpoint &&
        width < ScreenSize.tabletBreakpoint;
  }

  /// Returns true if the device is a desktop (width >= 1200)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ScreenSize.tabletBreakpoint;
  }
}

/// A widget that builds different layouts for mobile, tablet, and desktop
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceScreenType.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (DeviceScreenType.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

/// Responsive padding that scales based on screen size
EdgeInsetsGeometry getResponsivePadding(BuildContext context) {
  if (DeviceScreenType.isDesktop(context)) {
    return const EdgeInsets.all(32.0);
  } else if (DeviceScreenType.isTablet(context)) {
    return const EdgeInsets.all(24.0);
  } else {
    return const EdgeInsets.all(16.0);
  }
}

/// Gets responsive width for content containers
double getResponsiveWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (DeviceScreenType.isDesktop(context)) {
    // On desktop, constrain to a maximum width
    return width > 1400 ? 1200 : width * 0.8;
  } else if (DeviceScreenType.isTablet(context)) {
    // On tablet, use most of the width
    return width * 0.9;
  } else {
    // On mobile, use full width
    return width;
  }
}

/// A widget that centers and constrains content width based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool applyHorizontalConstraint;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.applyHorizontalConstraint = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!applyHorizontalConstraint) {
      return Padding(
        padding: padding ?? getResponsivePadding(context),
        child: child,
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: getResponsiveWidth(context)),
        child: Padding(
          padding: padding ?? getResponsivePadding(context),
          child: child,
        ),
      ),
    );
  }
}
