import 'package:flutter/material.dart';
import 'package:nevara_emp/models/incident_report.dart';
import 'package:nevara_emp/models/user_session.dart';
import 'package:nevara_emp/pages/incidents_page.dart';

/// Screen presenting store reports and incidents, allowing employees to register new reports.
///
/// This screen owns the report list and the active filter. [IncidentsPage]
/// receives the data and reports every user action back through callbacks.
class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);
  static const Color dangerCoral = Color(0xFFFF8A80);

  String _filter = 'Todos';

  final List<IncidentReport> _reports = [
    const IncidentReport(
      id: 'REP-041',
      type: 'Diferencia de Inventario',
      description: 'Faltante de 4 unidades de queso campesino en exhibición.',
      affectedQuantity: 4,
      dateTime: '06/11/2026 10:30',
      status: 'Pendiente',
      authorizedBy: 'carlos.mendoza@nevarafresh.com',
    ),
    const IncidentReport(
      id: 'REP-040',
      type: 'Avería de Producto',
      description: 'Empaque roto en lote de yogur natural durante reposición.',
      affectedQuantity: 2,
      dateTime: '06/11/2026 08:15',
      status: 'En revisión',
      authorizedBy: 'carlos.mendoza@nevarafresh.com',
    ),
    const IncidentReport(
      id: 'REP-039',
      type: 'Falla en Equipo',
      description: 'Nevera de carnes 2 con temperatura superior a lo normal (8°C).',
      affectedQuantity: 0,
      dateTime: '05/11/2026 17:45',
      status: 'En revisión',
      authorizedBy: 'carlos.mendoza@nevarafresh.com',
    ),
    const IncidentReport(
      id: 'REP-038',
      type: 'Vencimiento Próximo',
      description: 'Lote de panes artesanales próximos a caducar en 24 horas.',
      affectedQuantity: 12,
      dateTime: '04/11/2026 14:20',
      status: 'Resuelto',
      authorizedBy: 'carlos.mendoza@nevarafresh.com',
    ),
  ];

  List<IncidentReport> get _filteredReports {
    if (_filter == 'Todos') {
      return _reports;
    }
    return _reports.where((r) => r.status == _filter).toList();
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  void _showNewReportDialog() {
    final typeController =
        TextEditingController(text: 'Diferencia de Inventario');
    final descController = TextEditingController();
    final qtyController = TextEditingController();
    final emailController = TextEditingController(text: UserSession.currentEmail);
    final passwordController = TextEditingController();

    bool obscurePassword = true;
    String? errorMessage;

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
                      maxLines: 2,
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
                    const SizedBox(height: 16),

                    // Authorization requirement section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkBorderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lock_person_rounded,
                                  size: 16, color: activeGreen),
                              SizedBox(width: 6),
                              Text(
                                'Autorización Obligatoria',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Para completar este reporte debe ingresar su correo y contraseña:',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: primaryTextColor, fontSize: 13),
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              labelStyle: const TextStyle(
                                  color: secondaryTextColor, fontSize: 12),
                              prefixIcon: const Icon(Icons.email_outlined,
                                  size: 18, color: secondaryTextColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: darkBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: activeGreen),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            style: const TextStyle(
                                color: primaryTextColor, fontSize: 13),
                            decoration: InputDecoration(
                              labelText: 'Contraseña de confirmación',
                              labelStyle: const TextStyle(
                                  color: secondaryTextColor, fontSize: 12),
                              prefixIcon: const Icon(Icons.lock_outline,
                                  size: 18, color: secondaryTextColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 18,
                                  color: secondaryTextColor,
                                ),
                                onPressed: () {
                                  setDialogState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: darkBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: activeGreen),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: dangerCoral.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: dangerCoral.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                size: 16, color: dangerCoral),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                    color: dangerCoral, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    final desc = descController.text.trim();
                    final inputEmail = emailController.text.trim();
                    final inputPassword = passwordController.text.trim();

                    if (desc.isEmpty) {
                      setDialogState(() {
                        errorMessage =
                            'Debe ingresar una descripción de la situación.';
                      });
                      return;
                    }

                    if (inputEmail.isEmpty || inputPassword.isEmpty) {
                      setDialogState(() {
                        errorMessage =
                            'Debe ingresar el correo y la contraseña para completar el reporte.';
                      });
                      return;
                    }

                    // Strict validation against UserSession
                    final isValid = UserSession.validateCredentials(
                        inputEmail, inputPassword);

                    if (!isValid) {
                      setDialogState(() {
                        errorMessage =
                            'Credenciales incorrectas. Verifique correo y contraseña del usuario en sesión.';
                      });
                      return;
                    }

                    final qty = int.tryParse(qtyController.text.trim()) ?? 0;
                    setState(() {
                      _reports.insert(
                        0,
                        IncidentReport(
                          id: 'REP-0${40 + _reports.length + 2}',
                          type: selectedType,
                          description: desc,
                          affectedQuantity: qty,
                          dateTime: '08/11/2026 12:00',
                          status: 'Pendiente',
                          authorizedBy: inputEmail,
                        ),
                      );
                    });

                    Navigator.pop(ctx);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Reporte autorizado y completado exitosamente por $inputEmail.'),
                        backgroundColor: emeraldBrand,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldBrand,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Completar Reporte'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IncidentsPage(
      reports: _filteredReports,
      selectedFilter: _filter,
      onFilterSelected: _onFilterSelected,
      onNewReport: _showNewReportDialog,
    );
  }
}
