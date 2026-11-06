import 'package:flutter/material.dart';
import 'package:nevara_emp/models/store.dart';
import 'package:nevara_emp/screens/home_shell.dart';
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
          seedColor: const Color(0xFF2E7D32),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const HomeShell(),
              settings: settings,
            );
          case '/store-detail':
            final args = settings.arguments;
            if (args is Store) {
              return MaterialPageRoute(
                builder: (context) => StoreDetailScreen(store: args),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Error'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                body: const SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No se proporcionó una tienda válida.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Página no encontrada'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                body: const SafeArea(
                  child: Center(
                    child: Text('Ruta no encontrada'),
                  ),
                ),
              ),
              settings: settings,
            );
        }
      },
    );
  }
}
