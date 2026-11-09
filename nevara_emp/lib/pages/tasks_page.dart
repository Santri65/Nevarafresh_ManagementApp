import 'package:flutter/material.dart';
import 'package:nevara_emp/components/task_filter_sidebar.dart';
import 'package:nevara_emp/components/task_list.dart';
import 'package:nevara_emp/models/task.dart';

/// Presentational page for the tasks module.
///
/// All state lives in [TasksScreen]; this page only renders the data it
/// receives and reports user actions upward through callbacks.
class TasksPage extends StatelessWidget {
  final List<Task> filteredTasks;
  final TaskFilter selectedFilter;
  final String emptyMessage;
  final Function(TaskFilter) onFilterSelected;
  final Function(Task) onToggleTask;
  final Function(Task, String) onStatusChanged;
  final Function() onNewTask;

  static const Color darkBackground = Color(0xFF16181E);
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color emeraldBrand = Color(0xFF0F8478);

  const TasksPage({
    super.key,
    required this.filteredTasks,
    required this.selectedFilter,
    required this.emptyMessage,
    required this.onFilterSelected,
    required this.onToggleTask,
    required this.onStatusChanged,
    required this.onNewTask,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: const Text(
          'Tareas',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => onNewTask(),
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldBrand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Nueva Tarea',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        backgroundColor: darkSurface,
        foregroundColor: primaryTextColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 600;

            return Padding(
              padding: EdgeInsets.all(compact ? 12 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: compact ? 126 : 200,
                    child: TaskFilterSidebar(
                      selectedFilter: selectedFilter,
                      onFilterSelected: (filter) => onFilterSelected(filter),
                    ),
                  ),
                  SizedBox(width: compact ? 12 : 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TaskList(
                        tasks: filteredTasks,
                        onToggleTask: (task) => onToggleTask(task),
                        onStatusChanged: (task, status) =>
                            onStatusChanged(task, status),
                        emptyMessage: emptyMessage,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
