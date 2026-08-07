import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for HapticFeedback
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/domain/entities/note.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';
import 'package:nota_app/ui/core/widgets/nota_bar.dart';
import 'package:nota_app/ui/core/widgets/nota_dialog.dart'; // New Import
import 'package:nota_app/ui/core/widgets/nota_snack_bar.dart';
import 'package:nota_app/ui/library/cubit/library_cubit.dart';
import 'package:nota_app/ui/library/cubit/library_state.dart';
import 'package:nota_app/ui/library/view/library_empty_state.dart';
import 'package:nota_app/ui/library/widgets/nota_card.dart';
import 'package:nota_app/ui/library/widgets/nota_card_skeleton.dart';
import 'package:nota_app/ui/library/widgets/nota_fab.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocConsumer<LibraryCubit, LibraryState>(
        listener: (context, state) {
          state.maybeWhen(
            importSuccess: (file) {
              NotaSnackBar.show(
                context,
                message: 'Imported: ${file.path.split('/').last}',
              );
            },
            error: (message) {
              NotaSnackBar.show(context, message: message, isError: true);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          final List<Note> currentNotes = state.maybeWhen(
            loaded: (notes, _) => notes,
            orElse: () => [],
          );
          final Set<String> selectedIds = state.maybeWhen(
            loaded: (_, selected) => selected,
            orElse: () => <String>{},
          );

          final bool isSelectionMode = selectedIds.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isSelectionMode
                  ? NotaAppBar(
                      title: '${selectedIds.length} Selected',
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          context.read<LibraryCubit>().clearSelection();
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: colorScheme.error,
                          ),
                          onPressed: () async {
                            // 1. Trigger the confirmation dialog BEFORE deleting
                            final bool
                            confirmed = await NotaDialog.showConfirmation(
                              context,
                              title: 'Delete Documents?',
                              message:
                                  'Are you sure you want to delete ${selectedIds.length} document(s)? This action cannot be undone and will erase all associated highlights.',
                              confirmText: 'Delete',
                            );

                            // 2. Only proceed if the user tapped 'Delete'
                            if (confirmed && context.mounted) {
                              context
                                  .read<LibraryCubit>()
                                  .deleteSelectedNotes();
                            }
                          },
                        ),
                      ],
                    )
                  : NotaAppBar(
                      title: 'Nota',
                      leading: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        color: colorScheme.surface,
                        position: PopupMenuPosition.under,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgRadius,
                          side: BorderSide(
                            color: colorScheme.outline,
                            width: AppBorders.hairline,
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'select_all') {
                            context.read<LibraryCubit>().selectAll();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'select_all',
                            // 5. Polished Menu Item: Add an icon and proper spacing
                            child: Row(
                              children: [
                                Icon(
                                  Icons.checklist,
                                  size: 20,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Text('Select All', style: textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ],
                    ),

              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text("LIBRARY", style: textTheme.labelSmall),
              ),
              const SizedBox(height: AppSpacing.md),

              if (currentNotes.isEmpty && !isLoading)
                const LibraryEmptyState()
              else
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    children: [
                      if (isLoading) const NotaCardSkeleton(),
                      ...currentNotes.map(
                        (note) => NotaCard(
                          note: note,
                          isSelected: selectedIds.contains(note.id),
                          onTap: () {
                            if (isSelectionMode) {
                              // Fire haptic feedback on selection toggle
                              HapticFeedback.selectionClick();
                              context.read<LibraryCubit>().toggleSelection(
                                note.id,
                              );
                            } else {
                              // Normal mode: Route to reading screen
                              // TODO: Navigate to ReadingScreen
                            }
                          },
                          onLongPress: () {
                            // Fire haptic feedback when entering selection mode
                            HapticFeedback.selectionClick();
                            context.read<LibraryCubit>().toggleSelection(
                              note.id,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          final currentNotes = state.maybeWhen(
            loaded: (notes, _) => notes,
            orElse: () => [],
          );
          final selectedIds = state.maybeWhen(
            loaded: (_, selected) => selected,
            orElse: () => <String>{},
          );

          if ((currentNotes.isEmpty && !isLoading) || selectedIds.isNotEmpty) {
            return const SizedBox.shrink();
          }

          return NotaFab(
            onPressed: () => context.read<LibraryCubit>().importPdf(),
          );
        },
      ),
    );
  }
}
