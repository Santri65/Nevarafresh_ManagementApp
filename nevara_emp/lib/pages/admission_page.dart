import 'package:flutter/material.dart';
import 'package:nevara_emp/models/admission_shipment.dart';

/// Presentational page for the merchandise admission module.
///
/// All state lives in [AdmissionScreen]; this page only renders the data it
/// receives and reports user actions upward through callbacks.
class AdmissionPage extends StatelessWidget {
  final List<AdmissionShipment> shipments;
  final String currentEmail;
  final bool isLockedByOther;
  final String? activeClaimantName;
  final String? activeClaimantEmail;
  final Function(AdmissionShipment) onOpenAdmission;

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

  const AdmissionPage({
    super.key,
    required this.shipments,
    required this.currentEmail,
    required this.isLockedByOther,
    required this.activeClaimantName,
    required this.activeClaimantEmail,
    required this.onOpenAdmission,
  });

  @override
  Widget build(BuildContext context) {
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
                              color:
                                  isLockedByOther ? dangerCoral : activeGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isLockedByOther
                                ? 'El empleado "${activeClaimantName ?? activeClaimantEmail}" ya está registrando una admisión activa. Solo un empleado puede operar a la vez.'
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
                                            ? warningOrange.withValues(
                                                alpha: 0.15)
                                            : Colors.blue.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isCompleted
                                          ? activeGreen.withValues(alpha: 0.5)
                                          : isInProcess
                                              ? warningOrange.withValues(
                                                  alpha: 0.5)
                                              : Colors.blue.withValues(
                                                  alpha: 0.5),
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
                                      : () => onOpenAdmission(item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: emeraldBrand,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.white12,
                                    disabledForegroundColor:
                                        secondaryTextColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
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
