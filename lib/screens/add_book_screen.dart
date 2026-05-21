import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../providers/book_provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  int pages = 0;
  bool isRead = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (v) => title = v?.trim() ?? '',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Author'),
                onSaved: (v) => author = v?.trim() ?? '',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter author' : null,
              ),
              TextFormField(
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
                    final book = Book(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: title,
                      author: author,
                      pages: pages,
                      isRead: isRead,
                    );
                    await provider.addBook(book);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
