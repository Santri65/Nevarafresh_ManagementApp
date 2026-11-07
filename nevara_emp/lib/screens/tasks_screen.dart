import 'package:flutter/material.dart';
import 'package:nevara_emp/components/task_filter_sidebar.dart';
import 'package:nevara_emp/components/task_list.dart';
import 'package:nevara_emp/models/task.dart';

/// Screen for consulting and updating the employee's operational tasks.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  static const Color darkBackground = Color(0xFF16181E);
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color primaryTextColor = Color(0xFFF1F5F9);

  TaskFilter _filter = TaskFilter.all;

  final List<Task> _tasks = [
    Task(
      id: 'TAR-001',
      description: 'Realizar conteo físico de frutas y verduras',
      priority: 'Alta',
      status: 'Pendiente',
      assignedDate: '06/11/2026',
    ),
    Task(
      id: 'TAR-002',
      description: 'Reponer productos de la góndola de lácteos',
      priority: 'Media',
      status: 'Pendiente',
      assignedDate: '06/11/2026',
    ),
    Task(
      id: 'TAR-003',
      description: 'Revisar productos próximos a vencer en panadería',
      priority: 'Alta',
      status: 'Pendiente',
      assignedDate: '05/11/2026',
    ),
    Task(
      id: 'TAR-004',
      description: 'Registrar recepción de mercancía del proveedor',
      priority: 'Media',
      status: 'Completada',
      assignedDate: '05/11/2026',
      closedDate: '05/11/2026',
    ),
    Task(
      id: 'TAR-005',
      description: 'Actualizar exhibición de la sección de carnes',
      priority: 'Baja',
      status: 'Completada',
      assignedDate: '04/11/2026',
      closedDate: '04/11/2026',
    ),
  ];

  List<Task> get _filteredTasks {
    switch (_filter) {
      case TaskFilter.pending:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  String get _emptyMessage {
    switch (_filter) {
      case TaskFilter.pending:
        return 'No tienes tareas pendientes.';
      case TaskFilter.completed:
        return 'Aún no has completado tareas.';
      case TaskFilter.all:
        return 'No hay tareas asignadas.';
    }
  }

  void _toggleTask(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      return;
    }

    setState(() {
      if (_tasks[index].isCompleted) {
        _tasks[index] = _tasks[index].copyWith(
          status: 'Pendiente',
          clearClosedDate: true,
        );
      } else {
        _tasks[index] = _tasks[index].copyWith(
          status: 'Completada',
          closedDate: '06/11/2026',
        );
      }
    });
  }

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
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            tooltip: 'Regresar',
            icon: const Icon(Icons.arrow_back_rounded),
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
            final filteredTasks = _filteredTasks;

            return Padding(
              padding: EdgeInsets.all(compact ? 12 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: compact ? 126 : 200,
                    child: TaskFilterSidebar(
                      selectedFilter: _filter,
                      onFilterSelected: (filter) {
                        setState(() {
                          _filter = filter;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: compact ? 12 : 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TaskList(
                        tasks: filteredTasks,
                        onToggleTask: _toggleTask,
                        emptyMessage: _emptyMessage,
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
