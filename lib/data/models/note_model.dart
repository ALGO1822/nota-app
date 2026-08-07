import 'package:hive_ce/hive.dart';
import 'package:nota_app/domain/entities/note.dart';

part 'note_model.g.dart'; 

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String filePath; // We need to store where the PDF is located on the device

  @HiveField(3)
  final DateTime lastAccessed; // Dates are better for sorting than hardcoded strings

  NoteModel({
    required this.id,
    required this.title,
    required this.filePath,
    required this.lastAccessed,
  });

  // A handy mapper to convert this database model into your clean UI entity
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      filePath: filePath,
      // For now, we will just format the date to a simple string
      lastAccessed: "${lastAccessed.day}/${lastAccessed.month}/${lastAccessed.year}",
    );
  }
}