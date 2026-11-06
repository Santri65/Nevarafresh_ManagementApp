import 'package:flutter/material.dart';

/// Operational metrics summary for the employee in dark mode.
class StatsRow extends StatelessWidget {
  final String tasks;
  final String movements;
  final String incidents;

  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);

  const StatsRow({
    super.key,
    required this.tasks,
    required this.movements,
    required this.incidents,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: darkCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: darkBorderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  size: 24,
                  color: Color(0xFF81C784),
                ),
                const SizedBox(height: 6),
                Text(
                  tasks,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Tareas',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 40,
              color: darkBorderColor,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swap_horiz_outlined,
                  size: 24,
                  color: Color(0xFF64B5F6),
                ),
                const SizedBox(height: 6),
                Text(
                  movements,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Movimientos',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 40,
              color: darkBorderColor,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.report_problem_outlined,
                  size: 24,
                  color: Color(0xFFFFB74D),
                ),
                const SizedBox(height: 6),
                Text(
                  incidents,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Novedades',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
