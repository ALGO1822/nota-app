import 'package:flutter/material.dart';
import 'package:nota_app/domain/entities/note.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';
import 'package:nota_app/ui/core/widgets/nota_bar.dart';
import 'package:nota_app/ui/library/widgets/nota_fab.dart';
import 'package:nota_app/ui/library/widgets/nota_list.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    final List<Note> dummyNotes = [
      const Note(id: '1', title: 'Structural Biology Basics...', lastAccessed: 'Last read 2h ago'),
      const Note(id: '2', title: 'System Design Interview Guide', lastAccessed: 'Yesterday'),
      const Note(id: '3', title: 'Cognitive Load Theory', lastAccessed: 'Oct 12'),
    ];
    return Scaffold(
      appBar: NotaAppBar(
        title: 'Nota',
        onMenuPressed: () {
          // TODO: Open drawer or handle menu tap
        },
        onSearchPressed: () {
          // TODO: Handle search tap
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              "LIBRARY",
              style: textTheme.labelSmall,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
      
          NotaList(listItems: dummyNotes)
        ],
      ),
      floatingActionButton: NotaFab(onPressed: () {}),
    );
  }
}

