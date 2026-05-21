import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../widgets/book_tile.dart';
import 'add_book_screen.dart';
import 'edit_book_screen.dart';

class BooksListScreen extends StatelessWidget {
  const BooksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books List'),
      ),
      body: provider.books.isEmpty
          ? const Center(child: Text('No books yet. Tap + to add one.'))
          : ListView.builder(
        itemCount: provider.books.length,
        itemBuilder: (context, index) {
          final book = provider.books[index];
          return BookTile(
            book: book,
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditBookScreen(book: book),
                ),
              );
            },
            onDelete: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm delete'),
                  content:
                  const Text('Are you sure you want to delete this book?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes')),
                  ],
                ),
              );
              if (confirm == true) {
                await provider.deleteBook(book.id);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted')));
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBookScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
