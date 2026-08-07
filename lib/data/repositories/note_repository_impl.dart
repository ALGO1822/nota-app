import 'dart:io';
import 'package:nota_app/data/models/note_model.dart';
import 'package:nota_app/domain/entities/note.dart';
import 'package:nota_app/domain/repositories/note_repository.dart';
import 'package:nota_app/services/hive_service.dart';

class NoteRepositoryImpl implements NoteRepository {
  final HiveService _hiveService;

  NoteRepositoryImpl(this._hiveService);

  @override
  Future<Note> importAndSavePdf(File file) async {
    // 1. Generate metadata for the new file
    final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = file.path.split('/').last; // Grabs just the "document.pdf" part

    final existingNotes = _hiveService.getAllNotes();
    final isDuplicate = existingNotes.any((note) => note.title == fileName);
    
    if (isDuplicate) {
      throw Exception("DUPLICATE_FILE");
    }
    // 2. Create the Hive database model
    final newNoteModel = NoteModel(
      id: uniqueId,
      title: fileName,
      filePath: file.path,
      lastAccessed: DateTime.now(),
    );

    // 3. Save it to local storage via the service
    await _hiveService.saveNote(newNoteModel);

    // 4. Return the clean entity to the UI
    return newNoteModel.toEntity();
  }

  @override
  Future<void> deleteNotes(List<String> ids) async {
    await _hiveService.deleteNotes(ids);
  }

  @override
  Future<List<Note>> getAllSavedNotes() async {
    // Grabs the raw database models, maps them to UI entities, and returns the list
    final models = _hiveService.getAllNotes();
    return models.map((model) => model.toEntity()).toList();
  }
}