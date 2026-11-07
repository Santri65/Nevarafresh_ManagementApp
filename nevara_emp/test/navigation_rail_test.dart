import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nevara_emp/components/app_navigation_rail.dart';
import 'package:nevara_emp/screens/home_shell.dart';

void main() {
  testWidgets('AppNavigationRail renders all required destinations',
      (WidgetTester tester) async {
    int selectedIndex = 0;
    bool isExtended = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppNavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (idx) {
              selectedIndex = idx;
            },
            isExtended: isExtended,
            onToggleExtended: () {
              isExtended = !isExtended;
            },
          ),
        ),
      ),
    );

    // Verify all 5 destinations are present
    expect(find.text('Inventario'), findsOneWidget);
    expect(find.text('Reportes'), findsOneWidget);
    expect(find.text('Traslados'), findsOneWidget);
    expect(find.text('Tareas'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });

  testWidgets('AppNavigationRail responds to selection taps',
      (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return AppNavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: (idx) {
                  setState(() {
                    selectedIndex = idx;
                  });
                },
                isExtended: false,
                onToggleExtended: () {},
              );
            },
          ),
        ),
      ),
    );

    // Tap on 'Traslados' (index 2)
    await tester.tap(find.text('Traslados'));
    await tester.pump();
    expect(selectedIndex, equals(2));

    // Tap on 'Reportes' (index 1)
    await tester.tap(find.text('Reportes'));
    await tester.pump();
    expect(selectedIndex, equals(1));
  });

  testWidgets('HomeShell switches screens via left navigation rail',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeShell(initialIndex: 0),
      ),
    );
    await tester.pumpAndSettle();

    // Initial screen should be Inventory
    expect(find.text('Inventario de Tienda'), findsOneWidget);

    // Switch to Reportes
    await tester.tap(find.text('Reportes'));
    await tester.pumpAndSettle();
    expect(find.text('Reportes y Novedades'), findsOneWidget);
    expect(find.text('Hacer Reporte'), findsOneWidget);

    // Switch to Traslados
    await tester.tap(find.text('Traslados'));
    await tester.pumpAndSettle();
    expect(find.text('Traslado de Productos'), findsOneWidget);
    expect(find.text('Solicitar Traslado'), findsOneWidget);
  });
}
