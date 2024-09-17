import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;

  @HiveField(2)
  String description;
  
  @HiveField(3)
  bool complete;

  Todo(
    {required this.id,
    required this.name, 
    this.description = '', 
    this.complete = false});

  @override
  String toString() {
    return '$name - $description (${complete ? "Completed" : "Pending"})';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'complete': complete ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map, [key]) {
    return Todo( 
      id: map['id'].toString(),
      name: map['name'],
      description: map['description'],
      complete: map['complete'] == 1,
    );
  }
  }

  class ToDoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    return Todo(
      id: reader.read(),
      name: reader.read(),
      description: reader.read(),
      complete: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.complete);
  }
  }