import 'package:flutter/material.dart';

/// Breakpoint helpers for a responsive layout that adapts to phone sizes
/// and respects safe areas.
///
/// MessConnect is a mobile-first app, so the breakpoints are tuned for
/// phones and small tablets.
class ResponsiveLayout {
  const ResponsiveLayout._();

  /// Small phones (e.g. < 360 logical px wide).
  static const double smallBreakpoint = 360;

  /// Standard phones up to compact tablets.
  static const double mediumBreakpoint = 600;

  static bool isSmall(BuildContext context) =>
      MediaQuery.sizeOf(context).width < smallBreakpoint;

  static bool isMedium(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= smallBreakpoint && width < mediumBreakpoint;
  }

  static bool isLarge(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mediumBreakpoint;

  /// Horizontal page padding that scales with the screen width.
  static double horizontalPadding(BuildContext context) =>
      isSmall(context) ? 12.0 : (isMedium(context) ? 16.0 : 24.0);

  /// A [SafeArea] wrapper used by all top-level screens so content never
  /// sits under notches, status bars, or home indicators.
  static Widget safe(Widget child) => SafeArea(child: child);

  /// Pushes [page] in a standard [MaterialPageRoute]. Convenience so feature
  /// screens don't repeat [Navigator] boilerplate.
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
