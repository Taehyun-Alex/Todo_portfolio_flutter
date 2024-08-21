class Todo {
  final String name;
  final String description;
  final bool complete;
  final Function(String message, int value)? create;

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
    return Todo( 
      id: map['id'].toString(),
      name: map['name'],
      description: map['description'],
      complete: map['complete']);
  }
  }