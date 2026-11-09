/// Filter options available for the task list.
enum TaskFilter { all, missing, inProgress, completed }

/// Model representing an operational task assigned to an employee.
class Task {
  static const String statusMissing = 'Faltante';
  static const String statusInProgress = 'En proceso';
  static const String statusCompleted = 'Terminado';

  final String id;
  final String description;
  final String priority;
  final String status;
  final String assignedDate;
  final String? closedDate;

  const Task({
    required this.id,
    required this.description,
    required this.priority,
    required this.status,
    required this.assignedDate,
    this.closedDate,
  });

  bool get isCompleted =>
      status == statusCompleted || status == 'Completada';

  bool get isInProgress =>
      status == statusInProgress;

  bool get isMissing =>
      status == statusMissing || status == 'Pendiente';

  Task copyWith({
    String? id,
    String? description,
    String? priority,
    String? status,
    String? assignedDate,
    String? closedDate,
    bool clearClosedDate = false,
  }) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedDate: assignedDate ?? this.assignedDate,
      closedDate: clearClosedDate ? null : (closedDate ?? this.closedDate),
    );
  }
}
