import 'package:flutter/material.dart';

/// Model representing an incident or operational report in the store.
class IncidentReport {
  final String id;
  final String type;
  final String description;
  final int affectedQuantity;
  final String dateTime;
  final String status;

  const IncidentReport({
    required this.id,
    required this.type,
    required this.description,
    required this.affectedQuantity,
    required this.dateTime,
    required this.status,
  });
}

/// Screen presenting store reports and incidents, allowing employees to register new reports.
class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  static const Color darkBackground = Color(0xFF16181E);
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);

  String _filter = 'Todos';

  final List<IncidentReport> _reports = [
    const IncidentReport(
      id: 'REP-041',
      type: 'Diferencia de Inventario',
      description: 'Faltante de 4 unidades de queso campesino en exhibición.',
      affectedQuantity: 4,
      dateTime: '06/11/2026 10:30',
      status: 'Pendiente',
    ),
    const IncidentReport(
      id: 'REP-040',
      type: 'Avería de Producto',
      description: 'Empaque roto en lote de yogur natural durante reposición.',
      affectedQuantity: 2,
      dateTime: '06/11/2026 08:15',
      status: 'En revisión',
    ),
    const IncidentReport(
      id: 'REP-039',
      type: 'Falla en Equipo',
      description: 'Nevera de carnes 2 con temperatura superior a lo normal (8°C).',
      affectedQuantity: 0,
      dateTime: '05/11/2026 17:45',
      status: 'En revisión',
    ),
    const IncidentReport(
      id: 'REP-038',
      type: 'Vencimiento Próximo',
      description: 'Lote de panes artesanales próximos a caducar en 24 horas.',
      affectedQuantity: 12,
      dateTime: '04/11/2026 14:20',
      status: 'Resuelto',
    ),
  ];

  List<IncidentReport> get _filteredReports {
    if (_filter == 'Todos') {
      return _reports;
    }
    return _reports.where((r) => r.status == _filter).toList();
  }

  void _showNewReportDialog() {
    final typeController = TextEditingController(text: 'Diferencia de Inventario');
    final descController = TextEditingController();
    final qtyController = TextEditingController();

    final reportTypes = [
      'Diferencia de Inventario',
      'Avería de Producto',
      'Falla en Equipo',
      'Vencimiento Próximo',
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        String selectedType = typeController.text;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: darkSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: darkBorderColor),
              ),
              title: const Row(
                children: [
                  Icon(Icons.assignment_late_outlined, color: activeGreen),
                  SizedBox(width: 8),
                  Text(
                    'Hacer Reporte',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Tipo de Novedad:',
                      style: TextStyle(color: secondaryTextColor, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: darkCardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: darkBorderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedType,
                          dropdownColor: darkSurface,
                          style: const TextStyle(color: primaryTextColor),
                          items: reportTypes.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedType = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      style: const TextStyle(color: primaryTextColor),
                      decoration: InputDecoration(
                        labelText: 'Descripción de la situación',
                        labelStyle: const TextStyle(color: secondaryTextColor),
                        hintText: 'Detalla lo ocurrido en tienda...',
                        hintStyle: const TextStyle(color: Color(0xFF64748B)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: darkBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: activeGreen),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: primaryTextColor),
                      decoration: InputDecoration(
                        labelText: 'Cantidad afectada (unidades/kg)',
                        labelStyle: const TextStyle(color: secondaryTextColor),
                        hintText: 'ej. 4',
                        hintStyle: const TextStyle(color: Color(0xFF64748B)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: darkBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: activeGreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: secondaryTextColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (descController.text.trim().isNotEmpty) {
                      final qty = int.tryParse(qtyController.text.trim()) ?? 0;
                      setState(() {
                        _reports.insert(
                          0,
                          IncidentReport(
                            id: 'REP-0${40 + _reports.length + 2}',
                            type: selectedType,
                            description: descController.text.trim(),
                            affectedQuantity: qty,
                            dateTime: '06/11/2026 12:00',
                            status: 'Pendiente',
                          ),
                        );
                      });
                    }
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldBrand,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Registrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Resuelto':
        return activeGreen;
      case 'En revisión':
        return const Color(0xFFFFB74D);
      case 'Pendiente':
      default:
        return const Color(0xFFEF5350);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reports = _filteredReports;

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text('Reportes y Novedades'),
        centerTitle: false,
        backgroundColor: darkSurface,
        foregroundColor: primaryTextColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: _showNewReportDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldBrand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add_alert_rounded, size: 18),
              label: const Text(
                'Hacer Reporte',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Todos',
                    'Pendiente',
                    'En revisión',
                    'Resuelto',
                  ].map((filter) {
                    final isSelected = _filter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _filter = filter;
                            });
                          }
                        },
                        selectedColor: emeraldBrand.withValues(alpha: 0.3),
                        backgroundColor: darkCardColor,
                        labelStyle: TextStyle(
                          color: isSelected ? activeGreen : secondaryTextColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: isSelected ? activeGreen : darkBorderColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Reports list
              Expanded(
                child: reports.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.assignment_turned_in_outlined,
                              size: 56,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Sin reportes en esta categoría',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Pulsa "Hacer Reporte" para registrar una novedad.',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final item = reports[index];
                          final statusColor = _statusColor(item.status);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: darkCardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: darkBorderColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black38,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item.id,
                                              style: const TextStyle(
                                                color: secondaryTextColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            item.type,
                                            style: const TextStyle(
                                              color: primaryTextColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: statusColor.withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Text(
                                          item.status,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                  const Divider(
                                    color: darkBorderColor,
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Afectadas: ${item.affectedQuantity} unidad(es)',
                                        style: const TextStyle(
                                          color: activeGreen,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        item.dateTime,
                                        style: const TextStyle(
                                          color: secondaryTextColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
