import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/book_model.dart';

class BookProvider extends ChangeNotifier {
  final Box<Book> _box = Hive.box<Book>('booksBox');

  List<Book> _books = [];
  List<Book> get books => _books;

  void loadBooksFromBox() {
    _books = _box.values.toList();
    notifyListeners();
  }

  void refresh() {
    _books = _box.values.toList();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await _box.add(book);
    loadBooksFromBox();
  }

  Future<void> updateBook(Book updatedBook) async {
    final key = _box.keys.firstWhere(
          (k) {
        final b = _box.get(k) as Book;
        return b.id == updatedBook.id;
      },
      orElse: () => null,
    );

    if (key != null) {
      await _box.put(key, updatedBook);
      loadBooksFromBox();
    }
  }

  Future<void> deleteBook(int bookId) async {
    final key = _box.keys.firstWhere(
          (k) {
        final b = _box.get(k) as Book;
        return b.id == bookId;
      },
      orElse: () => null,
    );

    if (key != null) {
      await _box.delete(key);
      loadBooksFromBox();
    }
  }

}