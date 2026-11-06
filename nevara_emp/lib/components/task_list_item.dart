import 'package:flutter/material.dart';
import 'package:nevara_emp/models/task.dart';

/// Card representing a single task with its completion control.
class TaskListItem extends StatelessWidget {
  final Task task;
  final Function() onToggle;

  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
  });

  Color get _priorityColor => switch (task.priority) {
        'Alta' => const Color(0xFFFF8A80),
        'Media' => const Color(0xFFFFD54F),
        'Baja' => const Color(0xFF81C784),
        _ => secondaryTextColor,
      };

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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => onToggle(),
              tooltip: completed
                  ? 'Marcar como pendiente'
                  : 'Marcar como completada',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              icon: Icon(
                completed
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                size: 26,
                color: completed ? activeGreen : secondaryTextColor,
              ),
            ),
            const SizedBox(width: 4),
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
                      decoration:
                          completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
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
                      Expanded(
                        child: Text(
                          completed ? 'Completada' : 'Pendiente',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: completed ? activeGreen : secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    completed && task.closedDate != null
                        ? 'Cerrada: ${task.closedDate}'
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
