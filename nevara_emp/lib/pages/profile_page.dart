import 'package:flutter/material.dart';
import 'package:nevara_emp/components/profile_actions.dart';
import 'package:nevara_emp/components/profile_header.dart';
import 'package:nevara_emp/components/stats_row.dart';
import 'package:nevara_emp/components/store_info_card.dart';
import 'package:nevara_emp/models/store.dart';

/// Presentational page for the store employee profile.
///
/// All state lives in [ProfileScreen]; this page only renders the data it
/// receives and reports user actions upward through callbacks.
class ProfilePage extends StatelessWidget {
  final String employeeName;
  final String employeeRole;
  final String employeeId;
  final Store store;
  final Function() onOpenStoreDetail;
  final Function() onLogout;

  static const Color darkBackground = Color(0xFF16181E);
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color primaryTextColor = Color(0xFFF1F5F9);

  const ProfilePage({
    super.key,
    required this.employeeName,
    required this.employeeRole,
    required this.employeeId,
    required this.store,
    required this.onOpenStoreDetail,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: darkSurface,
        foregroundColor: primaryTextColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProfileHeader(
                image: 'https://picsum.photos/400',
                name: employeeName,
                role: employeeRole,
                employeeId: employeeId,
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
                store: store,
                onTap: () => onOpenStoreDetail(),
              ),
              const SizedBox(height: 16),
              ProfileActions(
                primaryButtonText: 'Actualizar Información',
                secondaryButtonText: 'Cerrar Sesión',
                onSecondaryPressed: () => onLogout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
