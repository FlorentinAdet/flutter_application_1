// pages/todo_list_page.dart

import 'package:flutter/material.dart';
import '../widgets/add_task_modal.dart';

class TodoListPage extends StatefulWidget {
  final List<Map<String, String>> tasks;
  final Function(Map<String, String>) onTaskCompleted;
  final Function(String, String, String) onAddTask;

  TodoListPage({
    required this.tasks,
    required this.onTaskCompleted,
    required this.onAddTask,
  });

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          return ListTile(
            title: Text(task['title']!),
            subtitle: Text('Due: ${task['date']} \n${task['description']}'),
            isThreeLine: true,
            trailing: IconButton(
              icon: Icon(Icons.radio_button_unchecked),
              onPressed: () {
                _showCompletionDialog(context, task);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddTaskModal(
                onAddTask: (title, description, date) {
                  widget.onAddTask(title, description, date);
                  setState(() {}); // Rafraîchit l'interface après l'ajout
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, Map<String, String> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tâche complétée'),
          content: Text('Avez-vous terminé cette tâche ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                widget.onTaskCompleted(task); // Archive la tâche
                setState(() {}); // Rafraîchit l'interface après l'archivage
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }
}
