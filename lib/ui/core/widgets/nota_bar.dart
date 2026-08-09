import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';
import 'package:nota_app/ui/core/animations/nota_animation_library.dart';

class NotaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;

  const NotaAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  /// Helper to wrap the title in a wide pill
  Widget _buildPill(BuildContext context, Widget child) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      height: AppSizing.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(
          color: colorScheme.outline,
          width: AppBorders.hairline,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  /// Helper to wrap individual icon buttons in a perfect circle
  Widget _buildCircle(BuildContext context, Widget child) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      height: AppSizing.appBarHeight,
      width: AppSizing.appBarHeight, // Locking width to height creates a perfect square base
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle, // Forces the container into a perfect circle
        border: Border.all(
          color: colorScheme.outline,
          width: AppBorders.hairline,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: SizedBox(
          height: AppSizing.appBarHeight,
          child: Row(
            children: [
              // 1. Morphing Leading Circle
              NotaAnimations.sizeFade(
                isVisible: leading != null,
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: leading != null ? _buildCircle(context, leading!) : const SizedBox.shrink(),
                ),
              ),
              
              // 2. Expanded Title Pill
              Expanded(
                child: _buildPill(
                  context, 
                  DefaultTextStyle(
                    style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    child: title,
                  ),
                ),
              ),
              
              // 3. Morphing Actions Circles
              NotaAnimations.sizeFade(
                isVisible: actions != null && actions!.isNotEmpty,
                // Map over the actions list and give every icon its own perfect circle
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions?.map((action) => Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: _buildCircle(context, action),
                  )).toList() ?? [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        AppSizing.appBarHeight + (AppSpacing.sm * 2),
      );
}