import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nevara_emp/components/stats_row.dart';
import 'package:nevara_emp/components/store_info_card.dart';
import 'package:nevara_emp/models/store.dart';
import 'package:nevara_emp/screens/store_detail_screen.dart';

void main() {
  testWidgets('Components render smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const StatsRow(tasks: '8', movements: '34', incidents: '2'),
              StoreInfoCard(
                store: const Store(
                  id: 'TDA-003',
                  code: 'TDA-003',
                  name: 'Sede Principal Centro',
                  address: 'Cra. 5 # 12-34, Cali',
                  email: 'carlos.mendoza@nevarafresh.com',
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Tareas'), findsOneWidget);
    expect(find.text('Movimientos'), findsOneWidget);
    expect(find.text('Novedades'), findsOneWidget);
    expect(find.text('Sede Principal Centro (TDA-003)'), findsOneWidget);
  });

  testWidgets('Tapping store info card triggers onTap callback',
      (WidgetTester tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StoreInfoCard(
            store: const Store(
              id: 'TDA-003',
              code: 'TDA-003',
              name: 'Sede Principal Centro',
              address: 'Cra. 5 # 12-34, Cali',
              email: 'carlos.mendoza@nevarafresh.com',
            ),
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(StoreInfoCard));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('StoreDetailScreen renders store data correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: StoreDetailScreen(),
      ),
    );

    expect(find.text('Detalle de Sede'), findsOneWidget);
    expect(find.text('Sede Principal Centro'), findsOneWidget);
    expect(find.text('Código: TDA-003'), findsOneWidget);
    expect(find.text('Cra. 5 # 12-34, Cali'), findsOneWidget);
    expect(find.text('carlos.mendoza@nevarafresh.com'), findsOneWidget);
  });
}
