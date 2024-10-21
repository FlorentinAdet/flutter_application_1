import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Pour parser les dates au bon format

class TaskAgendaPage extends StatefulWidget {
  final List<Map<String, String>> tasks; // Les tâches avec les dates

  TaskAgendaPage({required this.tasks});

  @override
  TaskAgendaPageState createState() => TaskAgendaPageState();
}

class TaskAgendaPageState extends State<TaskAgendaPage> {
  late Map<DateTime, List<Map<String, String>>> _tasksByDate;
  DateTime _focusedDay = DateTime.now(); // Date actuellement focalisée
  DateTime? _selectedDay; // Date sélectionnée

  @override
  void initState() {
    super.initState();
    _tasksByDate =
        _groupTasksByDate(widget.tasks); // Organiser les tâches par date
  }

  // Regrouper les tâches par date
  Map<DateTime, List<Map<String, String>>> _groupTasksByDate(
      List<Map<String, String>> tasks) {
    Map<DateTime, List<Map<String, String>>> tasksByDate = {};
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    for (var task in tasks) {
      // Assure-toi que 'task['date']' correspond bien au format
      DateTime taskDate = dateFormat.parse(task['date']!);
      // Utilisation de "DateUtils.dateOnly" pour normaliser la date
      DateTime taskDay = DateUtils.dateOnly(taskDate);

      if (tasksByDate[taskDay] == null) {
        tasksByDate[taskDay] = [];
      }
      tasksByDate[taskDay]!.add(task);
    }
    return tasksByDate;
  }

  // Retourne les tâches d'un jour donné
  List<Map<String, String>> _getTasksForDay(DateTime day) {
    return _tasksByDate[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda des Tâches'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay,
                  day); // Vérifier si le jour sélectionné correspond
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = DateUtils.dateOnly(
                    selectedDay); // Normalise la date sélectionnée
                _focusedDay = DateUtils.dateOnly(
                    focusedDay); // Normalise le jour focalisé
              });
            },
            eventLoader: (day) {
              return _getTasksForDay(day); // Charger les tâches du jour
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, tasks) {
                return tasks.isNotEmpty
                    ? Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue, // Pastille bleue
                          ),
                        ),
                      )
                    : null; // Pas de pastille si aucune tâche
              },
            ),
          ),
          const SizedBox(height: 8.0),
          // Afficher les tâches du jour sélectionné
          Expanded(
            child: _selectedDay != null &&
                    _getTasksForDay(_selectedDay!).isNotEmpty
                ? TaskListWidget(
                    tasks: _getTasksForDay(
                        _selectedDay!)) // Liste des tâches pour le jour sélectionné
                : const Center(
                    child: Text(
                        'Aucune tâche pour ce jour.')), // Message si aucune tâche
          ),
        ],
      ),
    );
  }
}

// Widget pour afficher la liste des tâches
class TaskListWidget extends StatelessWidget {
  final List<Map<String, String>> tasks;

  TaskListWidget({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task['title']!),
          subtitle: Text('Description: ${task['description']}'),
        );
      },
    );
  }
}
