import 'package:flutter/material.dart';
import 'package:nevara_emp/components/empty_state.dart';

/// Screen presenting the incidents/novedades module placeholder.
class IncidentsScreen extends StatelessWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Novedades'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const SafeArea(
        child: EmptyState(
          icon: Icons.report_problem_outlined,
          title: 'Novedades',
          message: 'Próximamente',
        ),
      ),
    );
  }
}
