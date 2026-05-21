import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../providers/book_provider.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  const EditBookScreen({super.key, required this.book});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String author;
  late int pages;
  late bool isRead;

  @override
  void initState() {
    super.initState();
    title = widget.book.title;
    author = widget.book.author;
    pages = widget.book.pages;
    isRead = widget.book.isRead;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (v) => title = v?.trim() ?? '',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter title' : null,
              ),
              TextFormField(
                initialValue: author,
                decoration: const InputDecoration(labelText: 'Author'),
                onSaved: (v) => author = v?.trim() ?? '',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter author' : null,
              ),
              TextFormField(
                initialValue: pages.toString(),
                decoration: const InputDecoration(labelText: 'Pages'),
                keyboardType: TextInputType.number,
                onSaved: (v) => pages = int.tryParse(v ?? '0') ?? 0,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter pages';
                  if (int.tryParse(v) == null) return 'Enter a number';
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Read'),
                value: isRead,
                onChanged: (v) => setState(() => isRead = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final updated = Book(
                      id: widget.book.id,
                      title: title,
                      author: author,
                      pages: pages,
                      isRead: isRead,
                    );
                    await provider.updateBook(updated);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
