import 'package:flutter/material.dart';

class AddTaskModal extends StatefulWidget {
  final Function(String, String, String) onAddTask;

  AddTaskModal({required this.onAddTask});

  @override
  _AddTaskModalState createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _submitTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final date = _selectedDate != null
        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
        : 'No date selected';

    if (title.isNotEmpty && description.isNotEmpty) {
      widget.onAddTask(title, description, date);
      Navigator.pop(context);
    }
  }

  void _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(_selectedDate != null
                  ? 'Due: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'No date selected'),
              Spacer(),
              TextButton(
                onPressed: _selectDate,
                child: Text('Select Date'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _submitTask,
            child: Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
