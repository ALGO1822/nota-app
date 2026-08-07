import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class LibrarySearchEmptyState extends StatelessWidget {
  const LibrarySearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "No matching notes",
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: AppFonts.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Try searching with a different keyword.",
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}