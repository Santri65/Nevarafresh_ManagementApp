import 'package:flutter/material.dart';
import 'package:nevara_emp/models/admission_manager.dart';
import 'package:nevara_emp/models/user_session.dart';

/// Screen presenting incoming merchandise deliveries (Admisión / Recepción de Mercancía).
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
  static const Color darkBackground = Color(0xFF16181E);
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);
  static const Color warningOrange = Color(0xFFFFB74D);
  static const Color dangerCoral = Color(0xFFFF8A80);

  final AdmissionManager _admissionManager = AdmissionManager.instance;

  @override
  void initState() {
    super.initState();
    _admissionManager.addListener(_onStateUpdated);
  }

  @override
  void dispose() {
    _admissionManager.removeListener(_onStateUpdated);
    super.dispose();
  }

  void _onStateUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  void _openAdmissionProcess(AdmissionShipment shipment) {
    final currentEmail = UserSession.currentEmail;
    final currentName = UserSession.currentName;

    // Check if another employee already locked the admission process
    if (_admissionManager.isLockedByOther(currentEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Admisión bloqueada: Solo un empleado puede procesar admisiones a la vez. Actualmente en proceso por ${_admissionManager.activeClaimantEmail}.',
          ),
          backgroundColor: dangerCoral,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final emailConfirmController = TextEditingController();
    final obsController = TextEditingController(text: shipment.observations ?? '');
    String? dialogError;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            final isLockedByMe = _admissionManager.activeClaimantEmail == currentEmail &&
                _admissionManager.activeShipmentId == shipment.id;

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
                      _admissionManager.releaseClaim(shipment.id);
                    }
                    Navigator.pop(ctx);
                  },
                  child: const Text('Cancelar / Liberar Turno',
                      style: TextStyle(color: secondaryTextColor)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final enteredEmail = emailConfirmController.text.trim().toLowerCase();
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
                    final claimed = _admissionManager.claimAdmission(
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
                    _admissionManager.completeAdmission(
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
    final isLockedByOther = _admissionManager.isLockedByOther(currentEmail);
    final shipments = _admissionManager.shipments;

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text('Admisión de Mercancía'),
        centerTitle: false,
        backgroundColor: darkSurface,
        foregroundColor: primaryTextColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Concurrency policy banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLockedByOther
                      ? dangerCoral.withValues(alpha: 0.12)
                      : emeraldBrand.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isLockedByOther
                        ? dangerCoral.withValues(alpha: 0.5)
                        : emeraldBrand.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isLockedByOther
                          ? Icons.lock_clock_rounded
                          : Icons.verified_user_rounded,
                      color: isLockedByOther ? dangerCoral : activeGreen,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLockedByOther
                                ? 'Admisión bloqueada por concurrencia'
                                : 'Canal de Admisión Habilitado',
                            style: TextStyle(
                              color: isLockedByOther ? dangerCoral : activeGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isLockedByOther
                                ? 'El empleado "${_admissionManager.activeClaimantName ?? _admissionManager.activeClaimantEmail}" ya está registrando una admisión activa. Solo un empleado puede operar a la vez.'
                                : 'Solo un empleado en tienda puede realizar admisiones al tiempo. Tu usuario ($currentEmail) será asignado automáticamente.',
                            style: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Entregas y Cargas Programadas:',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Shipments list
              Expanded(
                child: ListView.builder(
                  itemCount: shipments.length,
                  itemBuilder: (context, index) {
                    final item = shipments[index];
                    final isCompleted = item.status == 'Completada';
                    final isInProcess = item.status == 'En proceso';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: darkCardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isCompleted
                              ? activeGreen.withValues(alpha: 0.4)
                              : isInProcess
                                  ? warningOrange.withValues(alpha: 0.6)
                                  : darkBorderColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(6),
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? activeGreen.withValues(alpha: 0.15)
                                        : isInProcess
                                            ? warningOrange.withValues(alpha: 0.15)
                                            : Colors.blue.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isCompleted
                                          ? activeGreen.withValues(alpha: 0.5)
                                          : isInProcess
                                              ? warningOrange.withValues(alpha: 0.5)
                                              : Colors.blue.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: TextStyle(
                                      color: isCompleted
                                          ? activeGreen
                                          : isInProcess
                                              ? warningOrange
                                              : Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.supplier,
                              style: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fecha programada: ${item.expectedDate}',
                              style: const TextStyle(
                                color: secondaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                            const Divider(color: darkBorderColor, height: 20),

                            // Items breakdown
                            const Text(
                              'Cargamento a recepcionar:',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: item.items.map((prod) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: darkBorderColor),
                                  ),
                                  child: Text(
                                    '${prod.name}: ${prod.quantity} ${prod.unit}',
                                    style: const TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            if (item.observations != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                'Obs: ${item.observations}',
                                style: const TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],

                            const SizedBox(height: 14),

                            // Action button
                            if (isCompleted)
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      color: activeGreen, size: 16),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Recibido por ${item.assignedEmployeeEmail ?? item.assignedEmployeeName} (${item.completedAt ?? "Completado"})',
                                      style: const TextStyle(
                                        color: activeGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: isLockedByOther
                                      ? null
                                      : () => _openAdmissionProcess(item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: emeraldBrand,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.white12,
                                    disabledForegroundColor: secondaryTextColor,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: Icon(
                                    isLockedByOther
                                        ? Icons.lock_outline_rounded
                                        : Icons.input_rounded,
                                    size: 18,
                                  ),
                                  label: Text(
                                    isLockedByOther
                                        ? 'Bloqueado por otro empleado'
                                        : isInProcess
                                            ? 'Continuar Admisión'
                                            : 'Iniciar Admisión de Productos',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
