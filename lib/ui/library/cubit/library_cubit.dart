import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/domain/repositories/local_file_repository.dart';
import 'package:nota_app/ui/library/cubit/library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LocalFileRepository _fileRepository;

  LibraryCubit(this._fileRepository) : super(const LibraryState.initial());

  Future<void> importPdf() async {
    try {
      final file = await _fileRepository.pickPdfFile();

      if (file == null) {
        // User canceled the OS picker. Do nothing, keep the current state.
        return; 
      }

      emit(const LibraryState.loading());

      // TODO: store file in local storage and update the list of notes in the state.
      // For now, we simulate a slight processing delay so you can see the shimmer UX.
      await Future.delayed(const Duration(milliseconds: 600));

      emit(LibraryState.importSuccess(file));
      
    } catch (e) {
      emit(const LibraryState.error("Failed to import PDF"));
    }
  }
}