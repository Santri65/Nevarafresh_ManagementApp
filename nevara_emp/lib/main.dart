import 'package:flutter/material.dart';
import 'package:nevara_emp/screens/home_shell.dart';
import 'package:nevara_emp/screens/login_screen.dart';
import 'package:nevara_emp/screens/store_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ghpphxrpwbbjoixrmaao.supabase.co',
    publishableKey: 'sb_publishable_W3XxesMpZS34uqMELMdmSQ_k1NOBA5z',
  );
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
        '/admission': (context) => const HomeShell(initialIndex: 3),
        '/tasks': (context) => const HomeShell(initialIndex: 4),
        '/profile': (context) => const HomeShell(initialIndex: 5),
        '/store-detail': (context) => const StoreDetailScreen(),
      },
    );
  }
}
