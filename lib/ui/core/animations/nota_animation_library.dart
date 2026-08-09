import 'package:flutter/material.dart';

class NotaAnimations {
  /// Slides a widget vertically out of view. Perfect for auto-hiding app bars.
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

  /// Smoothly animates the width of a widget down to zero while fading it out.
  /// Perfect for the segmented app bar morphing effect.
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