import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nevara_emp/components/stats_row.dart';
import 'package:nevara_emp/components/store_info_card.dart';

void main() {
  testWidgets('Components render smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              StatsRow(tasks: '8', movements: '34', incidents: '2'),
              StoreInfoCard(
                storeName: 'Sede Principal Centro',
                storeCode: 'TDA-003',
                storeAddress: 'Cra. 5 # 12-34, Cali',
                email: 'carlos.mendoza@nevarafresh.com',
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
}
