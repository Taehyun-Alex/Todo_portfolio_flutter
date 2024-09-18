import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';
import '../models/todo_list.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;

  const TodoWidget({required this.todo, super.key});

  @override
  State<TodoWidget> createState() => _TodoWidgetState();

}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2.0), // Border color and width
        borderRadius: BorderRadius.circular(10.0), // Optional: make the border rounded
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.todo.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,)
                ),
                Checkbox(
                          value: widget.todo.complete, 
                          onChanged: (value){
                            if (value == null) return;
                            setState(() {
                              Provider.of<TodoList>(context, listen: false).updateTodo(
                                Todo(
                                  id: widget.todo.id,
                                  name: widget.todo.name, 
                                  description: widget.todo.description,
                                  complete: value)
                              );
                            });
                      },
                    ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Consumer<TodoList>(
                    builder: (context, value, child){
                      return IconButton(
                        onPressed: (){
                            value.removeTodo(widget.todo);
                        }, 
                        icon: Icon(Icons.delete));
                    }),
                  ),
                  Padding(
                  padding: EdgeInsets.all(0),
                  child: Consumer<TodoList>(
                    builder: (context, value, child){
                      return IconButton(
                        onPressed: (){
                            _showEditDialog(context, widget.todo);
                        }, 
                        icon: Icon(Icons.edit));
                    }),
                  )
            ]
          ),
          Column(
            children: [
              Center(
                child: Text(
                    widget.todo.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
              )
          )],
          )
        ],
      ),
    );
  }
  
}

void _showEditDialog(BuildContext context, Todo todo) {
  TextEditingController titleController = TextEditingController(text: todo.name);
  TextEditingController descriptionController = TextEditingController(text: todo.description);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Update the task with the new details
              Provider.of<TodoList>(context, listen: false).updateTodo(
                Todo(
                  id: todo.id,
                  name: titleController.text,
                  description: descriptionController.text,
                  complete: todo.complete, 
                ),
              );
              Navigator.of(context).pop(); 
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}