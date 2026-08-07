import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title; // Changed from String to Widget
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
            color: colorScheme.surfaceContainerHighest,
            borderRadius: AppRadius.pillRadius,
            border: Border.all(
              color: colorScheme.outline,
              width: AppBorders.hairline,
            ),
          ),
          child: Row(
            children: [
              // 1. Leading Icon Area
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: leading ?? const SizedBox(width: AppSizing.iconButtonSm),
              ),
              
              // 2. Title Area (Expanded to give the search field room to stretch)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Center(
                    child: DefaultTextStyle(
                      style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      child: title,
                    ),
                  ),
                ),
              ),
              
              // 3. Actions Area
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions ?? [const SizedBox(width: AppSizing.iconButtonSm)],
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