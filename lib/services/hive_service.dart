import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:nota_app/data/models/note_model.dart';

class HiveService {
  // A constant name for our storage box to prevent typos
  static const String _notesBoxName = 'notes_box';

  /// Initializes the local database. This must be called when the app starts.
  Future<void> init() async {
    // Finds the correct physical folder on the Android/iOS device to store data
    await Hive.initFlutter();
    
    // Registers the translator we generated in Step 1
    Hive.registerAdapter(NoteModelAdapter());
    
    // Opens the box so it is ready to be read from or written to
    await Hive.openBox<NoteModel>(_notesBoxName);
  }

  /// Returns the open box of notes
  Box<NoteModel> get _notesBox => Hive.box<NoteModel>(_notesBoxName);

  /// Saves a new note to the device
  Future<void> saveNote(NoteModel note) async {
    // .put() uses the note's ID as the key. If the ID already exists, it updates it.
    await _notesBox.put(note.id, note);
  }

  Future<void> deleteNotes(List<String> ids) async {
    await _notesBox.deleteAll(ids);
  }

  /// Retrieves all saved notes from the device
  List<NoteModel> getAllNotes() {
    // .values grabs everything in the box, and .toList() converts it to a standard Dart list
    return _notesBox.values.toList();
  }
}