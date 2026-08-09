import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaAnimations {
  /// Slides a widget vertically UP out of view. Perfect for top app bars.
  static Widget slideHide({
    required bool isVisible,
    required Widget child,
  }) {
    return AnimatedSlide(
      offset: isVisible ? Offset.zero : const Offset(0, -1.5),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      child: child,
    );
  }

  /// Slides a widget vertically DOWN out of view. Perfect for bottom FABs.
  static Widget slideHideBottom({
    required bool isVisible,
    required Widget child,
  }) {
    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedSlide(
        offset: isVisible ? Offset.zero : const Offset(0, 1.5),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isVisible ? 1.0 : 0.0,
          child: child,
        ),
      ),
    );
  }

  /// Smoothly collapses a circular button horizontally to 0 width.
  /// Eliminates the layout stutter caused by standard AnimatedSize.
  static Widget horizontalCollapse({
    required bool isVisible,
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      width: isVisible ? AppSizing.appBarHeight : 0.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: AppSizing.appBarHeight,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isVisible ? 1.0 : 0.0,
            child: child,
          ),
        ),
      ),
    );
  }
}