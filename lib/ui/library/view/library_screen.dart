import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/domain/entities/note.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';
import 'package:nota_app/ui/core/widgets/nota_bar.dart';
import 'package:nota_app/ui/core/widgets/nota_dialog.dart';
import 'package:nota_app/ui/core/widgets/nota_snack_bar.dart';
import 'package:nota_app/ui/library/cubit/library_cubit.dart';
import 'package:nota_app/ui/library/cubit/library_state.dart';
import 'package:nota_app/ui/library/view/library_empty_state.dart';
import 'package:nota_app/ui/library/view/library_search_empty_state.dart';
import 'package:nota_app/ui/library/widgets/nota_card.dart';
import 'package:nota_app/ui/library/widgets/nota_card_skeleton.dart';
import 'package:nota_app/ui/library/widgets/nota_fab.dart';
import 'package:nota_app/ui/reading/view/reading_screen.dart';

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
          
          final List<Note> currentNotes = state.maybeWhen(
            loaded: (_, filtered, __, ___) => filtered, 
            orElse: () => [],
          );
          final Set<String> selectedIds = state.maybeWhen(
            loaded: (_, __, selected, ___) => selected, 
            orElse: () => <String>{},
          );
          final bool isSearching = state.maybeWhen(
            loaded: (_, __, ___, searching) => searching, 
            orElse: () => false,
          );
          
          final bool isSelectionMode = selectedIds.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic AppBar: Morphs based on selection mode or search state
              if (isSelectionMode)
                NotaAppBar(
                  title: Text('${selectedIds.length} Selected'),
                  leading: IconButton(
                    icon: const Icon(Icons.close), 
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.read<LibraryCubit>().clearSelection();
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: colorScheme.error), 
                      onPressed: () async {
                        final bool confirmed = await NotaDialog.showConfirmation(
                          context,
                          title: 'Delete Note?',
                          message: 'Are you sure you want to delete ${selectedIds.length} note(s)? This action cannot be undone and will erase all associated highlights.',
                          confirmText: 'Delete',
                        );
                        
                        if (confirmed && context.mounted) {
                          context.read<LibraryCubit>().deleteSelectedNotes();
                        }
                      },
                    )
                  ],
                )
              else
                NotaAppBar(
                  title: isSearching
                      ? TextField(
                          autofocus: true,
                          style: textTheme.bodyLarge,
                          cursorColor: colorScheme.primary,
                          decoration: InputDecoration(
                            hintText: 'Search library...',
                            border: InputBorder.none,
                            hintStyle: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          onChanged: (query) => context.read<LibraryCubit>().search(query),
                        )
                      : const Text('Nota'),
                  leading: isSearching 
                      ? const SizedBox(width: AppSizing.iconButtonSm) 
                      : PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          color: colorScheme.surface,
                          position: PopupMenuPosition.under,
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
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.checklist,
                                    size: 20,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Text(
                                    'Select All',
                                    style: textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isSearching ? Icons.close : Icons.search,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => context.read<LibraryCubit>().toggleSearch(),
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
                if (isSearching)
                  const LibrarySearchEmptyState()
                else
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
                            HapticFeedback.selectionClick();
                            context.read<LibraryCubit>().toggleSelection(note.id);
                          } else {
                            // Route directly to the reading screen, passing the note data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadingScreen(note: note),
                              ),
                            );
                          }
                        },
                        onLongPress: () {
                          HapticFeedback.selectionClick();
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
          final currentNotes = state.maybeWhen(loaded: (_, filtered, __, ___) => filtered, orElse: () => []);
          final selectedIds = state.maybeWhen(loaded: (_, __, selected, ___) => selected, orElse: () => <String>{});
          
          if ((currentNotes.isEmpty && !isLoading) || selectedIds.isNotEmpty) {
            return const SizedBox.shrink();
          }
          
          return NotaFab(onPressed: () => context.read<LibraryCubit>().importPdf());
        },
      ),
    );
  }
}