import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class NotaFab extends StatelessWidget {
  final VoidCallback onPressed;

  const NotaFab({
    super.key, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: AppSizing.fabSize,
      height: AppSizing.fabSize,
      decoration: BoxDecoration(
        borderRadius: AppRadius.pillRadius,
        // Applies the multi-layered colored glow from your constants
        boxShadow: AppShadows.fab(colorScheme.primary),
      ),
      child: Material(
        color: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.pillRadius,
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.25),
            width: AppBorders.hairline,
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.pillRadius,
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 28, // Slightly larger than standard 24px for better visual balance
            ),
          ),
        ),
      ),
    );
  }
}