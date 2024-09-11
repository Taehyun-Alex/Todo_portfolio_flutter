import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool complete;

  Todo(
    {required this.id,
    required this.name, 
    required this.description, 
    this.complete = false});

  @override
  String toString() {
    return '$name - $description ($complete)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'complete': complete
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    bool? complete = map['complete'] is bool ? map['complete'] : null;

    complete ??= map['complete'] == 1 ? true : false;

    return Todo( 
      id: map['id'].toString(),
      name: map['name'],
      description: map['description'],
      complete: map['complete']);
  }
  }

  class TodoAdapter 