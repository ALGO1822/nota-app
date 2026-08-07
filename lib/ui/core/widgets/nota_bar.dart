import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;

  const NotaAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onSearchPressed,
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
            // Maps to AppColorsDark.surface2 in your AppTheme
            color: colorScheme.surfaceContainerHighest, 
            // Creates the pill shape (999 radius)
            borderRadius: AppRadius.pillRadius, 
            border: Border.all(
              // Maps to AppColorsDark.border in your AppTheme
              color: colorScheme.outline, 
              width: AppBorders.hairline,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: onMenuPressed,
                  splashRadius: AppSizing.iconButtonSm,
                ),
              ),
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: onSearchPressed,
                  splashRadius: AppSizing.iconButtonSm,
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