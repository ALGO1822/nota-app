import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nota_app/domain/entities/note.dart';

part 'library_state.freezed.dart';

@freezed
sealed class LibraryState with _$LibraryState{
  const factory LibraryState.initial() = LibraryInitial;

  const factory LibraryState.loading() = LibraryLoading;

  const factory LibraryState.importSuccess(
    File file,
  ) = LibraryImportSuccess;

  const factory LibraryState.loaded(
    List<Note> notes,
    Set<String> selectedIds,
  ) = LibraryLoaded;

  const factory LibraryState.error(
    String message,
  ) = LibraryError;
}