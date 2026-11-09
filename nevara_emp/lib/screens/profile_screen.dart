import 'package:flutter/material.dart';
import 'package:nevara_emp/models/store.dart';
import 'package:nevara_emp/models/user_session.dart';
import 'package:nevara_emp/pages/profile_page.dart';

/// Screen presenting the store employee profile.
///
/// This screen owns the employee data shown on the page and the navigation
/// actions. [ProfilePage] receives the data and reports every user action back
/// through callbacks.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final String _employeeName;
  late final String _employeeRole;
  late final String _employeeId;

  final Store _store = const Store(
    id: 'TDA-003',
    code: 'TDA-003',
    name: 'Sede Principal Centro',
    address: 'Cra. 5 # 12-34, Cali',
    email: 'carlos.mendoza@nevarafresh.com',
    status: 'Activo',
  );

  @override
  void initState() {
    super.initState();
    _employeeName = UserSession.currentName;
    _employeeRole = UserSession.currentRole;
    _employeeId = 'EMP-1024';
  }

  void _openStoreDetail() {
    Navigator.pushNamed(context, '/store-detail', arguments: _store);
  }

  void _handleLogout() {
    UserSession.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      employeeName: _employeeName,
      employeeRole: _employeeRole,
      employeeId: _employeeId,
      store: _store,
      onOpenStoreDetail: _openStoreDetail,
      onLogout: _handleLogout,
    );
  }
}
