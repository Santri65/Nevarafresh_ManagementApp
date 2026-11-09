/// Model representing a product in store inventory according to the MER model.
class InventoryItem {
  final String id;
  final String name;
  final String barcode;
  final String category;
  final String unit;
  final int totalAvailable;
  final int inWarehouse;
  final int onDisplay;
  final bool needsRestock;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.barcode,
    required this.category,
    required this.unit,
    required this.totalAvailable,
    required this.inWarehouse,
    required this.onDisplay,
    this.needsRestock = false,
  });

  InventoryItem copyWith({
    String? id,
    String? name,
    String? barcode,
    String? category,
    String? unit,
    int? totalAvailable,
    int? inWarehouse,
    int? onDisplay,
    bool? needsRestock,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      totalAvailable: totalAvailable ?? this.totalAvailable,
      inWarehouse: inWarehouse ?? this.inWarehouse,
      onDisplay: onDisplay ?? this.onDisplay,
      needsRestock: needsRestock ?? this.needsRestock,
    );
  }
}
