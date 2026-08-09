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

  Widget _buildCircle(BuildContext context, Widget child) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      height: AppSizing.appBarHeight,
      width: AppSizing.appBarHeight,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
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
              // 1. The Morphing Leading Circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                // Seals the padding gap smoothly as the button vanishes
                margin: EdgeInsets.only(right: leading != null ? AppSpacing.sm : 0.0),
                child: NotaAnimations.horizontalCollapse(
                  isVisible: leading != null,
                  // Passes a dummy circle when null so it shrinks beautifully instead of crashing
                  child: _buildCircle(context, leading ?? const SizedBox.shrink()),
                ),
              ),
              
              // 2. The Stretching Title/Search Pill
              Expanded(
                child: _buildPill(
                  context, 
                  DefaultTextStyle(
                    style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    child: title,
                  ),
                ),
              ),
              
              // 3. Actions Circles
              if (actions != null && actions!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!.map((action) => Padding(
                      padding: EdgeInsets.only(
                        left: action == actions!.first ? 0 : AppSpacing.sm
                      ),
                      child: _buildCircle(context, action),
                    )).toList(),
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