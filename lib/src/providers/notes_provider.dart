import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thanette/src/models/note.dart';
import 'package:thanette/src/models/drawing.dart';

class NotesProvider extends ChangeNotifier {
  final List<NoteModel> _all = [];
  final List<NoteModel> _visible = [];
  static const int _pageSize = 8;
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchQuery = '';

  List<NoteModel> get items => List.unmodifiable(_visible);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;

  void bootstrap() {
    // seed demo notes
    final seedColors = const [
      Color(0xFF7B61FF),
      Color(0xFFFFD166),
      Color(0xFF6EE7B7),
      Color(0xFF111827),
    ];
    for (int i = 0; i < 5; i++) {
      _all.add(
        NoteModel(
          id: '${i + 1}',
          title: i == 0 ? 'grocery day' : 'note ${i + 1}',
          body: i == 0
              ? 'carrots, cardamon, almond flour, cashews...'
              : 'some text for note ${i + 1}',
          color: seedColors[i % seedColors.length],
        ),
      );
    }
    loadNextPage();
  }

  void loadNextPage() {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    final start = _visible.length;
    final end = min(start + _pageSize, _all.length);
    _visible.addAll(_all.sublist(start, end));
    _hasMore = end < _all.length;
    _isLoading = false;
    notifyListeners();
  }

  String createNote() {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final colorPool = const [
      Color(0xFF7B61FF),
      Color(0xFFFFD166),
      Color(0xFF6EE7B7),
      Color(0xFF111827),
    ];
    final note = NoteModel(
      id: id,
      title: 'new note',
      body: '',
      color: colorPool[DateTime.now().millisecond % colorPool.length],
    );
    _all.insert(0, note);
    _visible.insert(0, note);
    notifyListeners();
    return id;
  }

  NoteModel? getById(String id) {
    try {
      return _all.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  void updateNote({
    required String id,
    required String title,
    required String body,
  }) {
    final index = _all.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _all[index].title = title.isEmpty ? 'untitled' : title;
    _all[index].body = body;
    final vIndex = _visible.indexWhere((n) => n.id == id);
    if (vIndex != -1) {
      _visible[vIndex] = _all[index];
    }
    notifyListeners();
  }

  void addAttachmentToNote(String noteId, NoteAttachment attachment) {
    final index = _all.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      _all[index].addAttachment(attachment);
      final vIndex = _visible.indexWhere((n) => n.id == noteId);
      if (vIndex != -1) {
        _visible[vIndex] = _all[index];
      }
      notifyListeners();
    }
  }

  void removeAttachmentFromNote(String noteId, String attachmentId) {
    final index = _all.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      _all[index].removeAttachment(attachmentId);
      final vIndex = _visible.indexWhere((n) => n.id == noteId);
      if (vIndex != -1) {
        _visible[vIndex] = _all[index];
      }
      notifyListeners();
    }
  }

  void updateNoteDrawing(String noteId, DrawingData? drawingData) {
    final index = _all.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      _all[index].updateDrawing(drawingData);
      final vIndex = _visible.indexWhere((n) => n.id == noteId);
      if (vIndex != -1) {
        _visible[vIndex] = _all[index];
      }
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _all.removeWhere((n) => n.id == id);
    _visible.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void searchNotes(String query) {
    _searchQuery = query.toLowerCase().trim();
    _visible.clear();

    if (_searchQuery.isEmpty) {
      // If search is empty, show all notes with pagination
      final end = min(_pageSize, _all.length);
      _visible.addAll(_all.sublist(0, end));
      _hasMore = end < _all.length;
    } else {
      // Filter notes by title containing the search query
      final filteredNotes = _all.where((note) {
        return note.title.toLowerCase().contains(_searchQuery);
      }).toList();

      _visible.addAll(filteredNotes);
      _hasMore = false; // No pagination for search results
    }

    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _visible.clear();
    final end = min(_pageSize, _all.length);
    _visible.addAll(_all.sublist(0, end));
    _hasMore = end < _all.length;
    notifyListeners();
  }
}
