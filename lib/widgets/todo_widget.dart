import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final TextEditingController newNameController = TextEditingController();
    final TextEditingController newDescriptionController =
        TextEditingController();
    final TextEditingController editNameController = TextEditingController();
    final TextEditingController editDescriptionController =
        TextEditingController();

    void showEditDialog(int index, ToDoProvider toDoProvider) {
      final todo = toDoProvider.todos[index];
      editNameController.text = todo.name;
      editDescriptionController.text = todo.description;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit To-do'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editNameController,
                  decoration: const InputDecoration(labelText: 'Edit Title'),
                ),
                TextField(
                  controller: editDescriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Edit Description'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (editNameController.text.isNotEmpty &&
                      editDescriptionController.text.isNotEmpty) {
                    toDoProvider.updateToDo(index, editNameController.text,
                        editDescriptionController.text);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          Consumer<ToDoProvider>(builder: (context, toDoProvider, child) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Completed: ${toDoProvider.completedCount}'),
                      Text('Uncompleted: ${toDoProvider.uncompletedCount}'),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      toDoProvider.deleteAll();
                    },
                    icon: const Icon(Icons.delete_forever)),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: newNameController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                      ),
                      TextField(
                        controller: newDescriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (newNameController.text.isNotEmpty &&
                        newDescriptionController.text.isNotEmpty) {
                      // Add the new ToDo using provider
                      context.read<ToDoProvider>().addToDo(
                          newNameController.text,
                          newDescriptionController.text);

                      // Clear the text fields
                      newNameController.clear();
                      newDescriptionController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child:
                Consumer<ToDoProvider>(builder: (context, toDoProvider, child) {
              return ListView.builder(
                itemCount: toDoProvider.todos.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = toDoProvider.todos[index];
                  return ListTile(
                    title: Text(
                      todo.name,
                      style: TextStyle(
                        decoration: todo.complete
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(todo.description),
                    leading: Checkbox(
                      value: todo.complete,
                      onChanged: (bool? value) {
                        toDoProvider.toggleToDoStatus(index);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showEditDialog(index, toDoProvider),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => toDoProvider.deleteToDo(index),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}