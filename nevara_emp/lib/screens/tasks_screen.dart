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
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);

  TaskFilter _filter = TaskFilter.all;

  final List<Task> _tasks = [
    const Task(
      id: 'TAR-001',
      description: 'Realizar conteo físico de frutas y verduras',
      priority: 'Alta',
      status: Task.statusMissing,
      assignedDate: '06/11/2026',
    ),
    const Task(
      id: 'TAR-002',
      description: 'Reponer productos de la góndola de lácteos',
      priority: 'Media',
      status: Task.statusInProgress,
      assignedDate: '06/11/2026',
    ),
    const Task(
      id: 'TAR-003',
      description: 'Revisar productos próximos a vencer en panadería',
      priority: 'Alta',
      status: Task.statusMissing,
      assignedDate: '05/11/2026',
    ),
    const Task(
      id: 'TAR-004',
      description: 'Registrar recepción de mercancía del proveedor',
      priority: 'Media',
      status: Task.statusCompleted,
      assignedDate: '05/11/2026',
      closedDate: '05/11/2026',
    ),
    const Task(
      id: 'TAR-005',
      description: 'Actualizar exhibición de la sección de carnes',
      priority: 'Baja',
      status: Task.statusCompleted,
      assignedDate: '04/11/2026',
      closedDate: '04/11/2026',
    ),
  ];

  List<Task> get _filteredTasks {
    switch (_filter) {
      case TaskFilter.missing:
        return _tasks.where((task) => task.isMissing).toList();
      case TaskFilter.inProgress:
        return _tasks.where((task) => task.isInProgress).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  String get _emptyMessage {
    switch (_filter) {
      case TaskFilter.missing:
        return 'No tienes tareas faltantes.';
      case TaskFilter.inProgress:
        return 'No tienes tareas en proceso.';
      case TaskFilter.completed:
        return 'Aún no has terminado tareas.';
      case TaskFilter.all:
        return 'No hay tareas asignadas.';
    }
  }

  void _toggleTask(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;

    setState(() {
      if (_tasks[index].isCompleted) {
        _tasks[index] = _tasks[index].copyWith(
          status: Task.statusMissing,
          clearClosedDate: true,
        );
      } else {
        _tasks[index] = _tasks[index].copyWith(
          status: Task.statusCompleted,
          closedDate: '08/11/2026',
        );
      }
    });
  }

  void _updateTaskStatus(Task task, String newStatus) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;

    setState(() {
      _tasks[index] = _tasks[index].copyWith(
        status: newStatus,
        closedDate: newStatus == Task.statusCompleted ? '08/11/2026' : null,
        clearClosedDate: newStatus != Task.statusCompleted,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Estado de "${task.description}" cambiado a: $newStatus'),
        backgroundColor: darkSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showNewTaskDialog() {
    final descController = TextEditingController();
    String priority = 'Media';
    String initialStatus = Task.statusMissing;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: darkSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: darkBorderColor),
              ),
              title: const Row(
                children: [
                  Icon(Icons.add_task_rounded, color: activeGreen),
                  SizedBox(width: 8),
                  Text(
                    'Nueva Tarea Operativa',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: descController,
                      maxLines: 2,
                      style: const TextStyle(color: primaryTextColor),
                      decoration: InputDecoration(
                        labelText: 'Descripción de la tarea',
                        labelStyle: const TextStyle(color: secondaryTextColor),
                        hintText: 'ej. Revisar existencias en pasillo 4',
                        hintStyle: const TextStyle(color: Color(0xFF64748B)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: darkBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: activeGreen),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Prioridad:',
                      style: TextStyle(color: secondaryTextColor, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: darkCardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: darkBorderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: priority,
                          dropdownColor: darkSurface,
                          style: const TextStyle(color: primaryTextColor),
                          items: const [
                            DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                            DropdownMenuItem(value: 'Media', child: Text('Media')),
                            DropdownMenuItem(value: 'Baja', child: Text('Baja')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => priority = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Estado Inicial:',
                      style: TextStyle(color: secondaryTextColor, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: darkCardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: darkBorderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: initialStatus,
                          dropdownColor: darkSurface,
                          style: const TextStyle(color: primaryTextColor),
                          items: const [
                            DropdownMenuItem(
                              value: Task.statusMissing,
                              child: Text('Faltante'),
                            ),
                            DropdownMenuItem(
                              value: Task.statusInProgress,
                              child: Text('En proceso'),
                            ),
                            DropdownMenuItem(
                              value: Task.statusCompleted,
                              child: Text('Terminado'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => initialStatus = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar',
                      style: TextStyle(color: secondaryTextColor)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (descController.text.trim().isNotEmpty) {
                      setState(() {
                        _tasks.insert(
                          0,
                          Task(
                            id: 'TAR-00${_tasks.length + 1}',
                            description: descController.text.trim(),
                            priority: priority,
                            status: initialStatus,
                            assignedDate: '08/11/2026',
                            closedDate: initialStatus == Task.statusCompleted
                                ? '08/11/2026'
                                : null,
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldBrand,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Crear Tarea'),
                ),
              ],
            );
          },
        );
      },
    );
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
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: _showNewTaskDialog,
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
                        onStatusChanged: _updateTaskStatus,
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
