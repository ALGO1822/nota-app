import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaCardSkeleton extends StatelessWidget {
  const NotaCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerHighest,
        highlightColor: colorScheme.surface,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(
              color: colorScheme.outline,
              width: AppBorders.hairline,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.smRadius,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.smRadius,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: 120,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.smRadius,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}