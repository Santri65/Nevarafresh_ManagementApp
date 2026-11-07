import 'package:flutter/material.dart';
import 'package:nevara_emp/screens/login_screen.dart';
import 'package:nevara_emp/screens/profile_screen.dart';
import 'package:nevara_emp/screens/store_detail_screen.dart';
import 'package:nevara_emp/screens/tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NevaraFresh Empleados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F8478),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/store-detail': (context) => const StoreDetailScreen(),
        '/tasks': (context) => const TasksScreen(),
      },
    );
  }
}
