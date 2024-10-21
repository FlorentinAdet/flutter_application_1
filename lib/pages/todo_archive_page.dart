import 'package:flutter/material.dart';

class TodoArchivePage extends StatefulWidget {
  final List<Map<String, String>> archivedTasks;
  final Function(Map<String, String>) onRestoreTask;

  TodoArchivePage({required this.archivedTasks, required this.onRestoreTask});

  @override
  _TodoArchivePageState createState() => _TodoArchivePageState();
}

class _TodoArchivePageState extends State<TodoArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archives des Tâches'),
      ),
      body: widget.archivedTasks.isEmpty
          ? Center(child: Text('Aucune tâche archivée.'))
          : ListView.builder(
              itemCount: widget.archivedTasks.length,
              itemBuilder: (context, index) {
                final task = widget.archivedTasks[index];
                return ListTile(
                  title: Text(task['title']!),
                  subtitle: Text(task['description']!),
                  trailing: IconButton(
                    icon: Icon(Icons.restore),
                    onPressed: () {
                      setState(() {
                        if (index >= 0 && index < widget.archivedTasks.length) {
                          // Vérifier si l'index est valide avant de retirer l'élément
                          widget.onRestoreTask(task);
                          widget.archivedTasks.removeAt(index);
                        }
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
