import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota_app/domain/repositories/local_file_repository.dart';
import 'package:nota_app/ui/library/cubit/library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LocalFileRepository _fileRepository;

  LibraryCubit(this._fileRepository) : super(LibraryState.initial());

  Future<void> importPdf() async {
    emit(LibraryState.loading());

    try {
      final file = await _fileRepository.pickPdfFile();

      if (file != null) {
        emit(LibraryState.importSuccess(file));
      } else {
        emit(const LibraryState.initial());
      }
    } catch (e) {
      emit(const LibraryState.error("Failed to import PDF"));
    }
  }
}