import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transition that provides a smooth fade transition between routes
class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({required super.child, super.key, super.name, super.arguments, super.restorationId})
    : super(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
}

/// Custom page transition that slides from bottom to top
class SlideUpTransitionPage extends CustomTransitionPage<void> {
  SlideUpTransitionPage({required super.child, super.key, super.name, super.arguments, super.restorationId})
    : super(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.3);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation.drive(CurveTween(curve: Curves.easeOut)), child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      );
}

/// Standard platform-style horizontal slide transition (default Flutter behavior)
class HorizontalSlideTransitionPage extends CustomTransitionPage<void> {
  HorizontalSlideTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    bool reversed = false,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // The default Flutter transition slides from right to left (when going forward)
           // and from left to right (when going back)
           const begin = Offset(1.0, 0.0);
           const end = Offset.zero;
           final tween = reversed ? Tween(begin: -begin, end: end) : Tween(begin: begin, end: end);

           final offsetAnimation = animation.drive(tween.chain(CurveTween(curve: Curves.easeInOut)));

           return SlideTransition(position: offsetAnimation, child: child);
         },
         transitionDuration: const Duration(milliseconds: 300),
       );
}

/// Helper class that provides a standardized way to configure your router
class AppPageTransitions {
  /// Standard fade transition for main tab navigation
  static Page<dynamic> fade(BuildContext context, GoRouterState state, Widget child) {
    return FadeTransitionPage(child: child);
  }

  /// Slide up transition for detail pages
  static Page<dynamic> slideUp(BuildContext context, GoRouterState state, Widget child) {
    return SlideUpTransitionPage(child: child);
  }

  /// No transition - useful for shell routes
  static Page<dynamic> none(BuildContext context, GoRouterState state, Widget child) {
    return NoTransitionPage<void>(child: child);
  }

  /// Standard horizontal slide transition (default Flutter behavior)
  static Page<dynamic> horizontal(
    BuildContext context,
    GoRouterState state,
    Widget child, {
    bool reversed = false,
  }) {
    return HorizontalSlideTransitionPage(child: child, reversed: reversed);
  }
}
