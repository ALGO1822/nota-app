import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaSnackBar {
  /// Set [isError] to true to apply error theme colors to the border and icon.
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final snackBar = SnackBar(
      // Maps to surface2 in your AppTheme[cite: 3]
      backgroundColor: colorScheme.surfaceContainerHighest, 
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgRadius, // Matches your NoteCard corner radius[cite: 3]
        side: BorderSide(
          // Switches to the pure red error token if an error is flagged[cite: 3]
          color: isError ? colorScheme.error : colorScheme.outline,
          width: AppBorders.hairline,
        ),
      ),
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? colorScheme.error : colorScheme.primary, // Primary maps to accent[cite: 3]
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              // Maps to AppTextStyles.label (14px, medium weight)[cite: 3]
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );

    // Clears any currently visible snackbars before showing the new one
    // This prevents delayed stacking if the user taps a button rapidly
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}