import 'package:flutter/material.dart';
import 'package:nota_app/domain/entities/note.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaCard extends StatelessWidget {
  final Note note;

  const NotaCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      // Creates the spacing between cards in the list
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.lgRadius,
          onTap: () {
            // TODO: Handle note tap, e.g., navigate to note details
          },
          child: Ink(
            decoration: BoxDecoration(
              // Maps to AppColorsDark.surface[cite: 1]
              color: colorScheme.surface,
              borderRadius: AppRadius.lgRadius,
              border: Border.all(
                // Maps to AppColorsDark.border[cite: 1]
                color: colorScheme.outline,
                width: AppBorders.hairline,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      // Maps to AppColorsDark.surface2[cite: 1]
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: AppRadius.smRadius,
                    ),
                    child: Icon(
                      Icons.insert_drive_file_outlined,
                      // Maps to AppColorsDark.textSecondary[cite: 1]
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          // Maps to AppTextStyles.body but forces the semibold weight[cite: 1]
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: AppFonts.semibold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          note.lastAccessed,
                          // Maps to AppTextStyles.meta (textSecondary)[cite: 1]
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}