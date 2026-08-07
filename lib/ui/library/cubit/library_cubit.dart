import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/domain/repositories/local_file_repository.dart';
import 'package:nota_app/domain/repositories/note_repository.dart';
import 'package:nota_app/ui/library/cubit/library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LocalFileRepository _fileRepository;
  final NoteRepository _noteRepository;

  LibraryCubit(this._fileRepository, this._noteRepository) 
      : super(const LibraryState.initial());

  /// Fetches all notes from Hive and initializes the loaded state
  Future<void> loadNotes() async {
    try {
      emit(const LibraryState.loading());
      final notes = await _noteRepository.getAllSavedNotes();
      // Initialize with both lists identical, no selections, and search closed
      emit(LibraryState.loaded(notes, notes, {}, false));
    } catch (e) {
      emit(const LibraryState.error("Failed to load notes"));
    }
  }

  /// Handles the end-to-end import flow with duplicate validation
  Future<void> importPdf() async {
    try {
      final file = await _fileRepository.pickPdfFile();
      if (file == null) return; // User canceled the file picker

      emit(const LibraryState.loading());

      await _noteRepository.importAndSavePdf(file);

      emit(LibraryState.importSuccess(file));
      await loadNotes();

    } catch (e) {
      if (e.toString().contains("DUPLICATE_FILE")) {
        emit(const LibraryState.error("Note is already in your library."));
        await loadNotes();
      } else {
        emit(const LibraryState.error("Failed to import PDF"));
        await loadNotes();
      }
    }
  }

  /// Toggles the selection state of a specific note ID
  void toggleSelection(String id) {
    state.maybeWhen(
      loaded: (allNotes, filteredNotes, selectedIds, isSearching) {
        final newSelection = Set<String>.from(selectedIds);
        
        if (newSelection.contains(id)) {
          newSelection.remove(id);
        } else {
          newSelection.add(id);
        }
        
        emit(LibraryState.loaded(allNotes, filteredNotes, newSelection, isSearching));
      },
      orElse: () {},
    );
  }

  /// Selects all available notes in the current view
  void selectAll() {
    state.maybeWhen(
      loaded: (allNotes, filteredNotes, _, isSearching) {
        final allIds = filteredNotes.map((n) => n.id).toSet();
        emit(LibraryState.loaded(allNotes, filteredNotes, allIds, isSearching));
      },
      orElse: () {},
    );
  }

  /// Clears all selections to exit selection mode
  void clearSelection() {
    state.maybeWhen(
      loaded: (allNotes, filteredNotes, _, isSearching) {
        emit(LibraryState.loaded(allNotes, filteredNotes, {}, isSearching));
      },
      orElse: () {},
    );
  }

  /// Deletes all selected notes from device storage
  Future<void> deleteSelectedNotes() async {
    await state.maybeWhen(
      loaded: (_, __, selectedIds, ___) async {
        if (selectedIds.isEmpty) return;
        
        emit(const LibraryState.loading());
        await _noteRepository.deleteNotes(selectedIds.toList());
        await loadNotes();
      },
      orElse: () async {},
    );
  }

  /// Opens or closes the search view
  void toggleSearch() {
    state.maybeWhen(
      loaded: (allNotes, _, selectedIds, isSearching) {
        // When closing search, restore filteredNotes back to allNotes
        emit(LibraryState.loaded(allNotes, allNotes, selectedIds, !isSearching));
      },
      orElse: () {},
    );
  }

  /// Instantly filters notes based on the search query
  void search(String query) {
    state.maybeWhen(
      loaded: (allNotes, _, selectedIds, isSearching) {
        final lowerQuery = query.toLowerCase();
        
        final results = allNotes.where((note) {
          return note.title.toLowerCase().contains(lowerQuery);
        }).toList();

        emit(LibraryState.loaded(allNotes, results, selectedIds, isSearching));
      },
      orElse: () {},
    );
  }
}