import 'package:nota_app/domain/entities/note.dart';
import 'dart:io';

abstract class NoteRepository {
  /// Takes a selected PDF file, saves its metadata, and returns the unified Note entity
  Future<Note> importAndSavePdf(File file);
  
  /// Loads all previously saved notes for the Library screen
  Future<List<Note>> getAllSavedNotes();

  // Deletes multiple notes by their IDs. This is useful for batch deletion in the Library screen.
  Future<void> deleteNotes(List<String> ids);
}