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
      color: widget.todo.complete
      ? Theme.of(context).primaryColor
      : Theme.of(context).highlightColor,
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.todo.name,
                  style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.black),
                ),
              ),
              Checkbox(
                value: widget.todo.complete,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    Provider.of<TodoList>(context, listen: false).UpdateTodo(
                      Todo(
                        id: widget.todo.id,
                        name: widget.todo.name,
                        description: widget.todo.description,
                        complete: value
                      )
                    );
                  });
                },
              )
            ],
          ),
          Center(
            child: Text(
              widget.todo.description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            ),
        ],
      ),
    );
  }
}