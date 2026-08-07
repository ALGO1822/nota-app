import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:nota_app/domain/repositories/local_file_repository.dart';

class LocalFileRepositoryImpl implements LocalFileRepository {
  @override
  Future<File?> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}