import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const NotaAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Accessing your predefined theme colors
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Container(
          height: AppSizing.appBarHeight,
          decoration: BoxDecoration(
            // Maps to AppColorsDark.surface2 in your AppTheme[cite: 3]
            color: colorScheme.surfaceContainerHighest, 
            // Creates the pill shape (999 radius)[cite: 3]
            borderRadius: AppRadius.pillRadius, 
            border: Border.all(
              // Maps to AppColorsDark.border in your AppTheme[cite: 3]
              color: colorScheme.outline, 
              width: AppBorders.hairline,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Leading Icon Area
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                // If no leading widget is passed, render an empty box to maintain spacing
                child: leading ?? const SizedBox(width: AppSizing.iconButtonSm),
              ),
              
              // 2. Title Area
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // 3. Actions Area
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  // If no actions are passed, render an empty box to maintain balance
                  children: actions ?? [const SizedBox(width: AppSizing.iconButtonSm)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This is required when implementing PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(
        AppSizing.appBarHeight + (AppSpacing.sm * 2),
      );
}