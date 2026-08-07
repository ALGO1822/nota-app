import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/domain/repositories/local_file_repository.dart';
import 'package:nota_app/domain/repositories/note_repository.dart';
import 'package:nota_app/ui/library/cubit/library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LocalFileRepository _fileRepository;
  final NoteRepository _noteRepository;

  LibraryCubit(this._fileRepository, this._noteRepository) : super(const LibraryState.initial());

  Future<void> importPdf() async {
    try {
      final file = await _fileRepository.pickPdfFile();

      if (file == null) return; // User canceled the file picker

      emit(const LibraryState.loading());

      // TODO: store file in local storage and update the list of notes in the state.
      // For now, we simulate a slight processing delay so you can see the shimmer UX.
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

  Future<void> loadNotes() async {
    try {
      emit(const LibraryState.loading());
      final notes = await _noteRepository.getAllSavedNotes();
      emit(LibraryState.loaded(notes, {}));
    } catch (e) {
      emit(const LibraryState.error("Failed to load notes"));
    }
  }

  void toggleSelection(String id) {
    state.maybeWhen(
      loaded: (notes, selectedIds) {
        final newSelection = Set<String>.from(selectedIds);

        if (newSelection.contains(id)) {
          newSelection.remove(id);
        } else {
          newSelection.add(id);
        }

        emit(LibraryState.loaded(notes, newSelection));
      },
      orElse: () {},
    );
  }

  void clearSelection() {
    state.maybeWhen(
      loaded: (notes, _) => emit(LibraryState.loaded(notes, {})),
      orElse: () {},
    );
  }

  Future<void> deleteSelectedNotes() async {
    await state.maybeWhen(
      loaded: (notes, selectedIds) async {
        if (selectedIds.isEmpty) return;

        emit(const LibraryState.loading());
        await _noteRepository.deleteNotes(selectedIds.toList());
        await loadNotes();
      },
      orElse: () {},
    );
  }
}