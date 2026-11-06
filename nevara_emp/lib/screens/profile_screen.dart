import 'package:flutter/material.dart';
import 'package:nevara_emp/components/profile_actions.dart';
import 'package:nevara_emp/components/profile_header.dart';
import 'package:nevara_emp/components/stats_row.dart';
import 'package:nevara_emp/components/store_info_card.dart';
import 'package:nevara_emp/models/store.dart';

/// Screen presenting the store employee profile.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Store _store = const Store(
    id: 'TDA-003',
    code: 'TDA-003',
    name: 'Sede Principal Centro',
    address: 'Cra. 5 # 12-34, Cali',
    email: 'carlos.mendoza@nevarafresh.com',
    status: 'Activo',
  );

  void _openStoreDetail() {
    Navigator.pushNamed(context, '/store-detail', arguments: _store);
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ProfileHeader(
                image: 'https://picsum.photos/400',
                name: 'Carlos Andrés Mendoza',
                role: 'Encargado de inventario',
                employeeId: 'EMP-1024',
                status: 'Activo',
              ),
              const SizedBox(height: 16),
              const StatsRow(
                tasks: '8',
                movements: '34',
                incidents: '2',
              ),
              const SizedBox(height: 16),
              StoreInfoCard(
                store: _store,
                onTap: () => _openStoreDetail(),
              ),
              const SizedBox(height: 16),
              const ProfileActions(
                primaryButtonText: 'Actualizar Información',
                secondaryButtonText: 'Cerrar Sesión',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
