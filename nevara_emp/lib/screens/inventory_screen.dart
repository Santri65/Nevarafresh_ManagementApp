import 'package:flutter/material.dart';
import 'package:nevara_emp/components/empty_state.dart';

/// Screen presenting the inventory module placeholder.
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Inventario'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const SafeArea(
        child: EmptyState(
          icon: Icons.inventory_2_outlined,
          title: 'Inventario',
          message: 'Próximamente',
        ),
      ),
    );
  }
}
