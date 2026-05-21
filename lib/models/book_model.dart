import 'package:hive/hive.dart';

class Book {
  int id;
  String title;
  String author;
  int pages;
  bool isRead;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.pages,
    required this.isRead,
  });
}

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }
    return Book(
      id: fields[0] as int,
      title: fields[1] as String,
      author: fields[2] as String,
      pages: fields[3] as int,
      isRead: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.pages)
      ..writeByte(4)
      ..write(obj.isRead);
  }
}
