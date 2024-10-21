import 'package:flutter/material.dart';
import 'pages/todo_list_page.dart';
import 'pages/task_agenda_page.dart';
import 'pages/todo_archive_page.dart';
import 'widgets/bottom_navbar.dart';

void main() {
  runApp(TodoListApp());
}

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Map<String, String>> _tasks = [];
  List<Map<String, String>> _archivedTasks = [];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      TodoListPage(
        tasks: _tasks,
        onTaskCompleted: _archiveTask,
        onAddTask: _addTask,
      ),
      TaskAgendaPage(tasks: _tasks),
      TodoArchivePage(
        archivedTasks: _archivedTasks,
        onRestoreTask: _restoreTask, // Ajoute cette fonction de restauration
      ),
    ];
  }

  // Fonction pour ajouter une tâche
  void _addTask(String title, String description, String date) {
    setState(() {
      _tasks.add({
        'title': title,
        'description': description,
        'date': date,
      });
    });
  }

  // Fonction pour archiver une tâche
  void _archiveTask(Map<String, String> task) {
    setState(() {
      _tasks.remove(task);
      _archivedTasks.add(task);
    });
  }

  // Fonction pour restaurer une tâche
  void _restoreTask(Map<String, String> task) {
    setState(() {
      _archivedTasks.remove(task);
      _tasks.add(task); // Ajouter la tâche restaurée dans la liste des tâches
    });
  }

  // Fonction pour changer la page via la navbar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
