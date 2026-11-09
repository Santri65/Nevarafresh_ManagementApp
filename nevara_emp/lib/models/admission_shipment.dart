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
    bool clearAssignment = false,
    bool clearObservations = false,
  }) {
    return AdmissionShipment(
      id: id ?? this.id,
      supplier: supplier ?? this.supplier,
      expectedDate: expectedDate ?? this.expectedDate,
      status: status ?? this.status,
      assignedEmployeeEmail: clearAssignment
          ? null
          : (assignedEmployeeEmail ?? this.assignedEmployeeEmail),
      assignedEmployeeName: clearAssignment
          ? null
          : (assignedEmployeeName ?? this.assignedEmployeeName),
      items: items ?? this.items,
      observations: clearObservations
          ? null
          : (observations ?? this.observations),
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
