import 'package:flutter/material.dart';

class NotaAnimations {
  /// Slides a widget vertically UP out of view. Perfect for top app bars.
  static Widget slideHide({
    required bool isVisible,
    required Widget child,
  }) {
    return AnimatedSlide(
      offset: isVisible ? Offset.zero : const Offset(0, -1.5), // Negative Y goes up
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
      ignoring: !isVisible, // Prevents invisible taps when hidden
      child: AnimatedSlide(
        offset: isVisible ? Offset.zero : const Offset(0, 1.5), // Positive Y goes down
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

  /// Smoothly animates the width of a widget down to zero while fading it out.
  static Widget sizeFade({
    required bool isVisible,
    required Widget child,
  }) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isVisible ? 1.0 : 0.0,
        child: isVisible ? child : const SizedBox.shrink(),
      ),
    );
  }
}