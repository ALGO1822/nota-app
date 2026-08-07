import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaDialog {
  /// Displays a highly styled confirmation dialog matching the app's aesthetic.
  /// Returns `true` if the user confirms, and `false` if they cancel.
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Maps to AppColorsDark.surface to maintain the dark-room aesthetic
          backgroundColor: colorScheme.surface,
          // Kills the default Material 3 blue tint injection
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgRadius,
            side: BorderSide(
              color: colorScheme.outline,
              width: AppBorders.hairline,
            ),
          ),
          title: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: AppFonts.semibold,
            ),
          ),
          content: Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actionsPadding: const EdgeInsets.only(
            right: AppSpacing.lg,
            bottom: AppSpacing.md,
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Returns false
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Returns true
              style: TextButton.styleFrom(
                // Uses the pure red error token for destructive actions[cite: 4]
                foregroundColor: colorScheme.error,
              ),
              child: Text(
                confirmText,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: AppFonts.medium,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If the user taps outside the dialog to dismiss it, result is null. Default to false.
    return result ?? false;
  }
}
