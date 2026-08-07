import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/domain/entities/note.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';
import 'package:nota_app/ui/core/widgets/nota_bar.dart';
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
              NotaSnackBar.show(context, message: 'Imported: ${file.path.split('/').last}');
            },
            error: (message) {
              NotaSnackBar.show(context, message: message, isError: true);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
          
          final List<Note> currentNotes = state.maybeWhen(loaded: (notes, _) => notes, orElse: () => []);
          final Set<String> selectedIds = state.maybeWhen(loaded: (_, selected) => selected, orElse: () => <String>{});
          
          final bool isSelectionMode = selectedIds.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic AppBar: Morphs based on selection mode
              isSelectionMode 
                ? NotaAppBar(
                    title: '${selectedIds.length} Selected',
                    leading: IconButton(
                      icon: const Icon(Icons.close), 
                      onPressed: () => context.read<LibraryCubit>().clearSelection(),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: colorScheme.error), 
                        onPressed: () => context.read<LibraryCubit>().deleteSelectedNotes(),
                      )
                    ],
                  )
                : NotaAppBar(
                    title: 'Nota',
                    leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                    actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
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
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    children: [
                      if (isLoading) const NotaCardSkeleton(),
                      ...currentNotes.map((note) => NotaCard(
                        note: note,
                        isSelected: selectedIds.contains(note.id),
                        onTap: () {
                          if (isSelectionMode) {
                            // If selecting, tap adds/removes from selection
                            context.read<LibraryCubit>().toggleSelection(note.id);
                          } else {
                            // Normal mode: Route to reading screen
                            // TODO: Navigate to ReadingScreen
                          }
                        },
                        onLongPress: () {
                          context.read<LibraryCubit>().toggleSelection(note.id);
                        },
                      )),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
          final currentNotes = state.maybeWhen(loaded: (notes, _) => notes, orElse: () => []);
          final selectedIds = state.maybeWhen(loaded: (_, selected) => selected, orElse: () => <String>{});
          
          // Hide FAB if empty, loading, OR currently selecting items to delete
          if ((currentNotes.isEmpty && !isLoading) || selectedIds.isNotEmpty) {
            return const SizedBox.shrink();
          }
          
          return NotaFab(onPressed: () => context.read<LibraryCubit>().importPdf());
        },
      ),
    );
  }
}