import 'package:flutter/foundation.dart';
import 'package:nevara_emp/models/inventory_repository.dart';

/// Single item in an incoming shipment.
class AdmissionProduct {
  final String name;
  final int quantity;
  final String unit;
  final String category;

  const AdmissionProduct({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
  });
}

/// Represents an incoming merchandise delivery at the store (MER: RecepciónMercancía).
class AdmissionShipment {
  final String id;
  final String supplier;
  final String expectedDate;
  final String status; // 'Pendiente', 'En proceso', 'Completada'
  final String? assignedEmployeeEmail;
  final String? assignedEmployeeName;
  final List<AdmissionProduct> items;
  final String? observations;
  final String? completedAt;

  const AdmissionShipment({
    required this.id,
    required this.supplier,
    required this.expectedDate,
    required this.status,
    this.assignedEmployeeEmail,
    this.assignedEmployeeName,
    required this.items,
    this.observations,
    this.completedAt,
  });

  AdmissionShipment copyWith({
    String? id,
    String? supplier,
    String? expectedDate,
    String? status,
    String? assignedEmployeeEmail,
    String? assignedEmployeeName,
    List<AdmissionProduct>? items,
    String? observations,
    String? completedAt,
  }) {
    return AdmissionShipment(
      id: id ?? this.id,
      supplier: supplier ?? this.supplier,
      expectedDate: expectedDate ?? this.expectedDate,
      status: status ?? this.status,
      assignedEmployeeEmail: assignedEmployeeEmail ?? this.assignedEmployeeEmail,
      assignedEmployeeName: assignedEmployeeName ?? this.assignedEmployeeName,
      items: items ?? this.items,
      observations: observations ?? this.observations,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Manager enforcing that only one employee in the store can conduct product admission at a time.
class AdmissionManager extends ChangeNotifier {
  static final AdmissionManager instance = AdmissionManager._internal();

  factory AdmissionManager() => instance;

  AdmissionManager._internal();

  // Active concurrency lock
  String? _activeClaimantEmail;
  String? _activeClaimantName;
  String? _activeShipmentId;

  String? get activeClaimantEmail => _activeClaimantEmail;
  String? get activeClaimantName => _activeClaimantName;
  String? get activeShipmentId => _activeShipmentId;

  bool get isLocked => _activeClaimantEmail != null;

  bool isLockedByOther(String currentEmail) {
    if (!isLocked) return false;
    return _activeClaimantEmail?.trim().toLowerCase() != currentEmail.trim().toLowerCase();
  }

  final List<AdmissionShipment> _shipments = [
    const AdmissionShipment(
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
      observations: 'Camión con refrigeración a 4°C. Revisión de empaques requerida.',
    ),
    const AdmissionShipment(
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
    const AdmissionShipment(
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

  List<AdmissionShipment> get shipments => List.unmodifiable(_shipments);

  /// Claims the admission lock for a specific shipment.
  /// Returns false if already locked by another employee.
  bool claimAdmission({
    required String shipmentId,
    required String userEmail,
    required String userName,
  }) {
    if (isLockedByOther(userEmail)) {
      return false;
    }

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

    notifyListeners();
    return true;
  }

  /// Cancels / releases the lock if the employee cancels the reception.
  void releaseClaim(String shipmentId) {
    if (_activeShipmentId == shipmentId) {
      _activeClaimantEmail = null;
      _activeClaimantName = null;
      _activeShipmentId = null;

      final index = _shipments.indexWhere((s) => s.id == shipmentId);
      if (index != -1 && _shipments[index].status == 'En proceso') {
        _shipments[index] = _shipments[index].copyWith(
          status: 'Pendiente',
          assignedEmployeeEmail: null,
          assignedEmployeeName: null,
        );
      }

      notifyListeners();
    }
  }

  /// Completes the admission, increments inventory stock, and unlocks admission for others.
  bool completeAdmission({
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

    _shipments[index] = shipment.copyWith(
      status: 'Completada',
      assignedEmployeeEmail: userEmail,
      observations: observations.isNotEmpty ? observations : shipment.observations,
      completedAt: '08/11/2026 15:00',
    );

    // Release lock so others can conduct subsequent admissions
    if (_activeShipmentId == shipmentId) {
      _activeClaimantEmail = null;
      _activeClaimantName = null;
      _activeShipmentId = null;
    }

    notifyListeners();
    return true;
  }
}
