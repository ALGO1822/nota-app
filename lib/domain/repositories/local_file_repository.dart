import 'dart:io';

abstract class LocalFileRepository {
  Future<File?> pickPdfFile();
}