import 'package:flutter/material.dart';
import 'package:nevara_emp/components/task_list_item.dart';
import 'package:nevara_emp/models/task.dart';

/// List of task cards with their completion controls.
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onToggleTask;
  final String emptyMessage;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1F27),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF323744), width: 1),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 32,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 10),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < tasks.length; index++) ...[
          TaskListItem(
            task: tasks[index],
            onToggle: () => onToggleTask(tasks[index]),
          ),
          if (index != tasks.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}
