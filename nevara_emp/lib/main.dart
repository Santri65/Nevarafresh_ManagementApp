import 'package:flutter/material.dart';
import 'package:nevara_emp/screens/home_shell.dart';
import 'package:nevara_emp/screens/login_screen.dart';
import 'package:nevara_emp/screens/security_screen.dart';
import 'package:nevara_emp/screens/store_detail_screen.dart';

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
        '/home': (context) => const HomeShell(),
        '/inventory': (context) => const HomeShell(initialIndex: 0),
        '/reports': (context) => const HomeShell(initialIndex: 1),
        '/transfers': (context) => const HomeShell(initialIndex: 2),
        '/tasks': (context) => const HomeShell(initialIndex: 3),
        '/profile': (context) => const HomeShell(initialIndex: 4),
        '/store-detail': (context) => const StoreDetailScreen(),
        '/security': (context) => const SecurityScreen(),
      },
    );
  }
}
