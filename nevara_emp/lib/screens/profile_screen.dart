import 'package:flutter/material.dart';
import 'package:nevara_emp/components/profile_actions.dart';
import 'package:nevara_emp/components/profile_header.dart';
import 'package:nevara_emp/components/stats_row.dart';
import 'package:nevara_emp/components/store_info_card.dart';

/// Screen presenting the store employee profile.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ProfileHeader(
                image: 'https://picsum.photos/400',
                name: 'Carlos Andrés Mendoza',
                role: 'Encargado de inventario',
                employeeId: 'EMP-1024',
                status: 'Activo',
              ),
              SizedBox(height: 16),
              StatsRow(
                tasks: '8',
                movements: '34',
                incidents: '2',
              ),
              SizedBox(height: 16),
              StoreInfoCard(
                storeName: 'Sede Principal Centro',
                storeCode: 'TDA-003',
                storeAddress: 'Cra. 5 # 12-34, Cali',
                email: 'carlos.mendoza@nevarafresh.com',
              ),
              SizedBox(height: 16),
              ProfileActions(
                primaryButtonText: 'Actualizar Información',
                secondaryButtonText: 'Cerrar Sesión',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: const Color(0xFF757575),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
