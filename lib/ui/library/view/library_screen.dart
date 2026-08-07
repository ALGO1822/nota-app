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

    final List<Note> dummyNotes = [
      
      const Note(
        id: '1',
        title: 'Structural Biology Basics...',
        lastAccessed: 'Last read 2h ago',
      ),
      const Note(
        id: '2',
        title: 'System Design Interview Guide',
        lastAccessed: 'Yesterday',
      ),
      const Note(
        id: '3',
        title: 'Cognitive Load Theory',
        lastAccessed: 'Oct 12',
      ),
    
    ];
    return Scaffold(
      appBar: NotaAppBar(
        title: 'Nota',
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {
          // TODO: Implement menu action
        }),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {
          // TODO: Implement search action
        })],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text("LIBRARY", style: textTheme.labelSmall),
          ),
          const SizedBox(height: AppSpacing.md),

          BlocConsumer<LibraryCubit, LibraryState>(
            listener: (context, state) {
              state.maybeWhen(
                importSuccess: (file) {
                  NotaSnackBar.show(
                    context, 
                    message: 'Imported: ${file.path.split('/').last}',
                  );
                },
                error: (message) {
                  NotaSnackBar.show(
                    context, 
                    message: message, 
                    isError: true,
                  );
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              final isLoading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              if (dummyNotes.isEmpty && !isLoading) {
                return const LibraryEmptyState();
              }
              return Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  children: [
                    if (isLoading) const NotaCardSkeleton(),
                    ...dummyNotes.map((note) => NotaCard(note: note)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: NotaFab(onPressed: () {
        context.read<LibraryCubit>().importPdf();
      }),
    );
  }
}
