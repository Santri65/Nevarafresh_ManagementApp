import 'package:flutter/material.dart';

/// Operational metrics summary for the employee.
class StatsRow extends StatelessWidget {
  final String tasks;
  final String movements;
  final String incidents;

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
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
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
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(height: 6),
                Text(
                  tasks,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B2A),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Tareas',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5B5E72),
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 40,
              color: const Color(0xFFE0E0E0),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swap_horiz_outlined,
                  size: 24,
                  color: Color(0xFF1976D2),
                ),
                const SizedBox(height: 6),
                Text(
                  movements,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B2A),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Movimientos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5B5E72),
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 40,
              color: const Color(0xFFE0E0E0),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.report_problem_outlined,
                  size: 24,
                  color: Color(0xFFE65100),
                ),
                const SizedBox(height: 6),
                Text(
                  incidents,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B2A),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Novedades',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5B5E72),
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
