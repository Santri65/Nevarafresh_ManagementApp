import 'package:flutter/material.dart';
import 'package:nevara_emp/models/admission_shipment.dart';
import 'package:nevara_emp/models/inventory_repository.dart';
import 'package:nevara_emp/models/user_session.dart';
import 'package:nevara_emp/pages/admission_page.dart';

/// Screen presenting incoming merchandise deliveries (Admisión / Recepción de Mercancía).
///
/// This screen owns the shipments list and the single-employee concurrency
/// lock. [AdmissionPage] receives the data and reports every user action back
/// through callbacks.
///
/// Enforces single-employee concurrency: only one employee at a time in the store can
/// process an admission, automatically binds to the logged-in device user, and requires
/// email confirmation to assume responsibility.
class AdmissionScreen extends StatefulWidget {
  const AdmissionScreen({super.key});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);
  static const Color dangerCoral = Color(0xFFFF8A80);

  late List<AdmissionShipment> _shipments;

  String? _activeClaimantEmail;
  String? _activeClaimantName;
  String? _activeShipmentId;

  static const List<AdmissionShipment> _initialShipments = [
    AdmissionShipment(
      id: 'REC-501',
      supplier: 'AgroFrescos del Valle S.A.',
      expectedDate: '08/11/2026 14:30',
      status: 'Pendiente',
      items: [
        AdmissionProduct(
          name: 'Aguacate Hass',
          quantity: 30,
          unit: 'kg',
          category: 'Frutas y Verduras',
        ),
        AdmissionProduct(
          name: 'Papaya Maradol',
          quantity: 25,
          unit: 'kg',
          category: 'Frutas y Verduras',
        ),
      ],
      observations:
          'Camión con refrigeración a 4°C. Revisión de empaques requerida.',
    ),
    AdmissionShipment(
      id: 'REC-502',
      supplier: 'Lácteos del Sur LTDA',
      expectedDate: '08/11/2026 16:00',
      status: 'Pendiente',
      items: [
        AdmissionProduct(
          name: 'Leche Entera 1L',
          quantity: 40,
          unit: 'un',
          category: 'Lácteos',
        ),
        AdmissionProduct(
          name: 'Queso Campesino 500g',
          quantity: 15,
          unit: 'un',
          category: 'Lácteos',
        ),
      ],
      observations: 'Entrega regular semanal con factura 9821.',
    ),
    AdmissionShipment(
      id: 'REC-500',
      supplier: 'Distribuidora Carnes del Campo',
      expectedDate: '07/11/2026 10:00',
      status: 'Completada',
      assignedEmployeeEmail: 'carlos.mendoza@nevarafresh.com',
      assignedEmployeeName: 'Carlos Andrés Mendoza',
      items: [
        AdmissionProduct(
          name: 'Pechuga de Pollo Fresca',
          quantity: 20,
          unit: 'kg',
          category: 'Carnes',
        ),
      ],
      observations: 'Recepción completa sin anomalías.',
      completedAt: '07/11/2026 10:45',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shipments = List<AdmissionShipment>.from(_initialShipments);
  }

  bool get _isLocked => _activeClaimantEmail != null;

  bool _isLockedByOther(String currentEmail) {
    if (!_isLocked) return false;
    return _activeClaimantEmail?.trim().toLowerCase() !=
        currentEmail.trim().toLowerCase();
  }

  /// Claims the admission lock for a specific shipment.
  /// Returns false if already locked by another employee.
  bool _claimAdmission({
    required String shipmentId,
    required String userEmail,
    required String userName,
  }) {
    if (_isLockedByOther(userEmail)) {
      return false;
    }

    setState(() {
      _activeClaimantEmail = userEmail;
      _activeClaimantName = userName;
      _activeShipmentId = shipmentId;

      final index = _shipments.indexWhere((s) => s.id == shipmentId);
      if (index != -1) {
        _shipments[index] = _shipments[index].copyWith(
          status: 'En proceso',
          assignedEmployeeEmail: userEmail,
          assignedEmployeeName: userName,
        );
      }
    });

    return true;
  }

  /// Cancels / releases the lock if the employee cancels the reception.
  void _releaseClaim(String shipmentId) {
    if (_activeShipmentId != shipmentId) return;

    setState(() {
      _activeClaimantEmail = null;
      _activeClaimantName = null;
      _activeShipmentId = null;

      final index = _shipments.indexWhere((s) => s.id == shipmentId);
      if (index != -1 && _shipments[index].status == 'En proceso') {
        _shipments[index] = _shipments[index].copyWith(
          status: 'Pendiente',
          clearAssignment: true,
        );
      }
    });
  }

  /// Completes the admission, increments inventory stock, and unlocks admission for others.
  bool _completeAdmission({
    required String shipmentId,
    required String userEmail,
    required String observations,
  }) {
    final index = _shipments.indexWhere((s) => s.id == shipmentId);
    if (index == -1) return false;

    final shipment = _shipments[index];

    // Add each received product into store inventory
    for (final prod in shipment.items) {
      InventoryRepository.instance.addStockFromAdmission(
        name: prod.name,
        quantity: prod.quantity,
        unit: prod.unit,
        category: prod.category,
      );
    }

    setState(() {
      _shipments[index] = shipment.copyWith(
        status: 'Completada',
        assignedEmployeeEmail: userEmail,
        observations:
            observations.isNotEmpty ? observations : shipment.observations,
        completedAt: '08/11/2026 15:00',
      );

      // Release lock so others can conduct subsequent admissions
      if (_activeShipmentId == shipmentId) {
        _activeClaimantEmail = null;
        _activeClaimantName = null;
        _activeShipmentId = null;
      }
    });

    return true;
  }

  void _openAdmissionProcess(AdmissionShipment shipment) {
    final currentEmail = UserSession.currentEmail;
    final currentName = UserSession.currentName;

    // Check if another employee already locked the admission process
    if (_isLockedByOther(currentEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Admisión bloqueada: Solo un empleado puede procesar admisiones a la vez. Actualmente en proceso por $_activeClaimantEmail.',
          ),
          backgroundColor: dangerCoral,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final emailConfirmController = TextEditingController();
    final obsController =
        TextEditingController(text: shipment.observations ?? '');
    String? dialogError;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            final isLockedByMe = _activeClaimantEmail == currentEmail &&
                _activeShipmentId == shipment.id;

            return AlertDialog(
              backgroundColor: darkSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: darkBorderColor),
              ),
              title: Row(
                children: [
                  const Icon(Icons.move_to_inbox_rounded, color: activeGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Admisión de Productos (${shipment.id})',
                      style: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Delivery Details
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: darkCardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: darkBorderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Proveedor: ${shipment.supplier}',
                            style: const TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fecha programada: ${shipment.expectedDate}',
                            style: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                            ),
                          ),
                          const Divider(color: darkBorderColor, height: 16),
                          const Text(
                            'Productos a recibir:',
                            style: TextStyle(
                              color: activeGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...shipment.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_box_outlined,
                                      size: 14, color: activeGreen),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${item.name} (${item.quantity} ${item.unit})',
                                      style: const TextStyle(
                                        color: primaryTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.category,
                                    style: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Automatic assigned employee (Non-editable, strict single-user)
                    const Text(
                      'Empleado receptor (Dispositivo actual):',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(
                        text: '$currentName ($currentEmail)',
                      ),
                      enabled: false, // Read only, locked to logged-in user
                      style: const TextStyle(
                        color: activeGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black38,
                        prefixIcon: const Icon(Icons.lock_rounded,
                            size: 18, color: activeGreen),
                        helperText:
                            'Fijado automáticamente al usuario en sesión. No se pueden poner otros empleados.',
                        helperMaxLines: 2,
                        helperStyle: const TextStyle(
                            color: secondaryTextColor, fontSize: 10),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: activeGreen.withValues(alpha: 0.5)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Confirmation email input
                    const Text(
                      'Confirmar correo para asumir la recepción:',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: emailConfirmController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          color: primaryTextColor, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu correo ($currentEmail)',
                        hintStyle: const TextStyle(
                            color: Color(0xFF64748B), fontSize: 12),
                        prefixIcon: const Icon(Icons.mark_email_read_outlined,
                            size: 18, color: secondaryTextColor),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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
                    const SizedBox(height: 14),

                    // Observations
                    TextField(
                      controller: obsController,
                      maxLines: 2,
                      style: const TextStyle(
                          color: primaryTextColor, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Observaciones de entrega',
                        labelStyle: const TextStyle(
                            color: secondaryTextColor, fontSize: 12),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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

                    if (dialogError != null) ...[
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
                                dialogError!,
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
                  onPressed: () {
                    if (isLockedByMe) {
                      _releaseClaim(shipment.id);
                    }
                    Navigator.pop(ctx);
                  },
                  child: const Text('Cancelar / Liberar Turno',
                      style: TextStyle(color: secondaryTextColor)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final enteredEmail =
                        emailConfirmController.text.trim().toLowerCase();
                    final expectedEmail = currentEmail.trim().toLowerCase();

                    if (enteredEmail.isEmpty) {
                      setDialogState(() {
                        dialogError =
                            'Debe ingresar su correo para confirmar la responsabilidad de la admisión.';
                      });
                      return;
                    }

                    if (enteredEmail != expectedEmail) {
                      setDialogState(() {
                        dialogError =
                            'El correo no coincide con el usuario en sesión ($expectedEmail). Solo usted puede recibir en este dispositivo.';
                      });
                      return;
                    }

                    // Enforce lock acquisition
                    final claimed = _claimAdmission(
                      shipmentId: shipment.id,
                      userEmail: currentEmail,
                      userName: currentName,
                    );

                    if (!claimed) {
                      setDialogState(() {
                        dialogError =
                            'Otro empleado ya inició una admisión. Solo un empleado puede realizar admisiones al mismo tiempo.';
                      });
                      return;
                    }

                    // Complete the admission and deposit to inventory
                    _completeAdmission(
                      shipmentId: shipment.id,
                      userEmail: currentEmail,
                      observations: obsController.text.trim(),
                    );

                    Navigator.pop(ctx);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Admisión de "${shipment.supplier}" completada con éxito por $currentEmail. Existencias actualizadas en el inventario.',
                        ),
                        backgroundColor: emeraldBrand,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldBrand,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Completar Admisión'),
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
    final currentEmail = UserSession.currentEmail;

    return AdmissionPage(
      shipments: _shipments,
      currentEmail: currentEmail,
      isLockedByOther: _isLockedByOther(currentEmail),
      activeClaimantName: _activeClaimantName,
      activeClaimantEmail: _activeClaimantEmail,
      onOpenAdmission: _openAdmissionProcess,
    );
  }
}
