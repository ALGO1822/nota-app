import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';
import 'package:nota_app/ui/library/cubit/library_cubit.dart';

class LibraryEmptyState extends StatelessWidget {
  const LibraryEmptyState({super.key});

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
              Icons.auto_awesome_motion_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Your library is empty",
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: AppFonts.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Import a PDF to start studying.",
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextButton.icon(
              onPressed: () => context.read<LibraryCubit>().importPdf(),
              icon: const Icon(Icons.add),
              label: const Text("Import PDF"),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.pillRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}