import 'package:flutter/material.dart';
import 'package:nevara_emp/models/task.dart';

/// Card representing a single task with status selection between Faltante, En proceso, Terminado.
class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final ValueChanged<String>? onStatusChanged;

  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color inProgressAmber = Color(0xFFFFD54F);
  static const Color missingCoral = Color(0xFFFF8A80);

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    this.onStatusChanged,
  });

  Color get _priorityColor => switch (task.priority) {
        'Alta' => const Color(0xFFFF8A80),
        'Media' => const Color(0xFFFFD54F),
        'Baja' => const Color(0xFF81C784),
        _ => secondaryTextColor,
      };

  Color get _statusColor {
    if (task.isCompleted) return activeGreen;
    if (task.isInProgress) return inProgressAmber;
    return missingCoral;
  }

  IconData get _statusIcon {
    if (task.isCompleted) return Icons.check_circle_rounded;
    if (task.isInProgress) return Icons.timelapse_rounded;
    return Icons.error_outline_rounded;
  }

  String get _displayStatus {
    if (task.isCompleted) return 'Terminado';
    if (task.isInProgress) return 'En proceso';
    return 'Faltante';
  }

  @override
  Widget build(BuildContext context) {
    final completed = task.isCompleted;

    return Card(
      elevation: 0,
      color: darkCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: darkBorderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick toggle button
            IconButton(
              onPressed: onToggle,
              tooltip: completed
                  ? 'Reabrir como Faltante'
                  : 'Marcar como Terminado',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
              icon: Icon(
                _statusIcon,
                size: 24,
                color: _statusColor,
              ),
            ),
            const SizedBox(width: 6),

            // Task content and status selector
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: completed ? secondaryTextColor : primaryTextColor,
                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      // Priority chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _priorityColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _priorityColor.withValues(alpha: 0.45),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          task.priority,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _priorityColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Interactive status menu
                      PopupMenuButton<String>(
                        tooltip: 'Cambiar estado',
                        onSelected: (newStatus) {
                          onStatusChanged?.call(newStatus);
                        },
                        color: const Color(0xFF1B1F27),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: darkBorderColor),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: Task.statusMissing,
                            child: Row(
                              children: [
                                Icon(Icons.error_outline_rounded,
                                    color: missingCoral, size: 16),
                                SizedBox(width: 8),
                                Text('Faltante',
                                    style: TextStyle(color: primaryTextColor)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: Task.statusInProgress,
                            child: Row(
                              children: [
                                Icon(Icons.timelapse_rounded,
                                    color: inProgressAmber, size: 16),
                                SizedBox(width: 8),
                                Text('En proceso',
                                    style: TextStyle(color: primaryTextColor)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: Task.statusCompleted,
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: activeGreen, size: 16),
                                SizedBox(width: 8),
                                Text('Terminado',
                                    style: TextStyle(color: primaryTextColor)),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _statusColor.withValues(alpha: 0.45),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _displayStatus,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _statusColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 14,
                                color: _statusColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    completed && task.closedDate != null
                        ? 'Terminada: ${task.closedDate}'
                        : 'Asignada: ${task.assignedDate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
