import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nevara_emp/models/admission_manager.dart';
import 'package:nevara_emp/models/inventory_repository.dart';
import 'package:nevara_emp/models/user_session.dart';
import 'package:nevara_emp/screens/admission_screen.dart';
import 'package:nevara_emp/screens/incidents_screen.dart';
import 'package:nevara_emp/screens/inventory_screen.dart';
import 'package:nevara_emp/screens/tasks_screen.dart';

void main() {
  setUp(() {
    UserSession.login(
      username: 'carlos.mendoza',
      password: 'password123',
    );
  });

  group('TasksScreen Functionality', () {
    testWidgets('renders tasks with Faltante, En proceso, and Terminado states',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TasksScreen()),
      );
      await tester.pumpAndSettle();

      // Check filters
      expect(find.text('Todas'), findsOneWidget);
      expect(find.text('Faltantes'), findsOneWidget);
      expect(find.text('En proceso'), findsWidgets);
      expect(find.text('Terminadas'), findsOneWidget);

      // Check status indicators are present
      expect(find.text('Faltante'), findsWidgets);
      expect(find.text('Terminado'), findsWidgets);
    });

    testWidgets('filtering tasks updates list by state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TasksScreen()),
      );
      await tester.pumpAndSettle();

      // Tap on 'Faltantes'
      await tester.tap(find.text('Faltantes'));
      await tester.pumpAndSettle();
      expect(find.text('Faltante'), findsWidgets);
      expect(find.text('Terminado'), findsNothing);

      // Tap on 'Terminadas'
      await tester.tap(find.text('Terminadas'));
      await tester.pumpAndSettle();
      expect(find.text('Terminado'), findsWidgets);
      expect(find.text('Faltante'), findsNothing);
    });
  });

  group('InventoryScreen Functionality', () {
    testWidgets('allows adding and selling units (decrement and increment)',
        (WidgetTester tester) async {
      final repo = InventoryRepository.instance;
      final initialStock = repo.items.first.totalAvailable;

      await tester.pumpWidget(
        const MaterialApp(home: InventoryScreen()),
      );
      await tester.pumpAndSettle();

      // Tap "Vender -1" on the first product
      final sellButtons = find.text('Vender -1');
      expect(sellButtons, findsWidgets);

      await tester.tap(sellButtons.first);
      await tester.pump();

      expect(repo.items.first.totalAvailable, equals(initialStock - 1));

      // Tap "Agregar +1" on the first product
      final addButtons = find.text('Agregar +1');
      expect(addButtons, findsWidgets);

      await tester.tap(addButtons.first);
      await tester.pump();

      expect(repo.items.first.totalAvailable, equals(initialStock));
    });

    testWidgets('allows adding a new product via dialog',
        (WidgetTester tester) async {
      final repo = InventoryRepository.instance;
      final initialCount = repo.items.length;

      await tester.pumpWidget(
        const MaterialApp(home: InventoryScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Agregar Producto'));
      await tester.pumpAndSettle();

      expect(find.text('Agregar Nuevo Producto'), findsOneWidget);

      // Enter name
      await tester.enterText(
        find.widgetWithText(TextField, 'Nombre del producto'),
        'Papaya Formosa Test',
      );
      await tester.pump();

      // Save
      await tester.tap(find.text('Guardar Producto'));
      await tester.pumpAndSettle();

      expect(repo.items.length, equals(initialCount + 1));
      expect(repo.items.first.name, equals('Papaya Formosa Test'));
    });
  });

  group('IncidentsScreen Functionality', () {
    testWidgets('requires email and password to complete report',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: IncidentsScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hacer Reporte'));
      await tester.pumpAndSettle();

      expect(find.text('Autorización Obligatoria'), findsOneWidget);

      // Try completing without password
      await tester.enterText(
        find.widgetWithText(TextField, 'Descripción de la situación'),
        'Falla en condensador refrigerador',
      );
      await tester.pump();

      await tester.tap(find.text('Completar Reporte'));
      await tester.pumpAndSettle();

      expect(
        find.text(
            'Debe ingresar el correo y la contraseña para completar el reporte.'),
        findsOneWidget,
      );

      // Now enter valid credentials
      await tester.enterText(
        find.widgetWithText(TextField, 'Contraseña de confirmación'),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.text('Completar Reporte'));
      await tester.pumpAndSettle();

      // Dialog closed and report added
      expect(find.text('Falla en condensador refrigerador'), findsOneWidget);
    });
  });

  group('AdmissionScreen Concurrency and Session', () {
    testWidgets('binds receiver to logged-in user and locks concurrency',
        (WidgetTester tester) async {
      final manager = AdmissionManager.instance;
      expect(manager.isLocked, isFalse);

      await tester.pumpWidget(
        const MaterialApp(home: AdmissionScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Admisión de Mercancía'), findsOneWidget);
      expect(find.text('Canal de Admisión Habilitado'), findsOneWidget);

      // Tap to start admission on the first shipment
      final startButtons = find.text('Iniciar Admisión de Productos');
      expect(startButtons, findsWidgets);

      await tester.tap(startButtons.first);
      await tester.pumpAndSettle();

      // Verify the helper text and receiver field exist
      expect(
        find.text(
            'Fijado automáticamente al usuario en sesión. No se pueden poner otros empleados.'),
        findsOneWidget,
      );

      // Close dialog
      await tester.tap(find.text('Cancelar / Liberar Turno'));
      await tester.pumpAndSettle();

      // Concurrency lock demonstration
      expect(
        manager.claimAdmission(
          shipmentId: 'REC-501',
          userEmail: 'carlos.mendoza@nevarafresh.com',
          userName: 'Carlos Andrés Mendoza',
        ),
        isTrue,
      );

      // Another employee attempt fails
      expect(
        manager.isLockedByOther('otro.empleado@nevarafresh.com'),
        isTrue,
      );
      expect(
        manager.claimAdmission(
          shipmentId: 'REC-502',
          userEmail: 'otro.empleado@nevarafresh.com',
          userName: 'Otro Empleado',
        ),
        isFalse,
      );

      // Release lock for cleanup
      manager.releaseClaim('REC-501');
      expect(manager.isLocked, isFalse);
    });
  });
}
