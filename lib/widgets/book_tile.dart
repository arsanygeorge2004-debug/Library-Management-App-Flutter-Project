import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookTile({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text('${book.author} • ${book.pages} pages'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(book.isRead ? Icons.check_circle : Icons.circle_outlined),
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
