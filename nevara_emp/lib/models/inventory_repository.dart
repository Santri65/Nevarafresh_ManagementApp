import 'package:flutter/foundation.dart';
import 'package:nevara_emp/models/inventory_item.dart';

/// Singleton in-memory repository managing store inventory items.
class InventoryRepository extends ChangeNotifier {
  static final InventoryRepository instance = InventoryRepository._internal();

  factory InventoryRepository() => instance;

  InventoryRepository._internal();

  final List<InventoryItem> _items = [
    const InventoryItem(
      id: 'PROD-001',
      name: 'Manzana Royal Gala',
      barcode: '7701234567891',
      category: 'Frutas y Verduras',
      unit: 'kg',
      totalAvailable: 85,
      inWarehouse: 50,
      onDisplay: 35,
    ),
    const InventoryItem(
      id: 'PROD-002',
      name: 'Leche Entera 1L',
      barcode: '7709876543210',
      category: 'Lácteos',
      unit: 'un',
      totalAvailable: 120,
      inWarehouse: 80,
      onDisplay: 40,
    ),
    const InventoryItem(
      id: 'PROD-003',
      name: 'Tomate Chonto',
      barcode: '7705432167894',
      category: 'Frutas y Verduras',
      unit: 'kg',
      totalAvailable: 32,
      inWarehouse: 12,
      onDisplay: 20,
      needsRestock: true,
    ),
    const InventoryItem(
      id: 'PROD-004',
      name: 'Pechuga de Pollo Fresca',
      barcode: '7706549873215',
      category: 'Carnes',
      unit: 'kg',
      totalAvailable: 45,
      inWarehouse: 25,
      onDisplay: 20,
    ),
    const InventoryItem(
      id: 'PROD-005',
      name: 'Arroz Blanco Especial 1kg',
      barcode: '7703216549872',
      category: 'Granos y Abarrotes',
      unit: 'un',
      totalAvailable: 210,
      inWarehouse: 150,
      onDisplay: 60,
    ),
    const InventoryItem(
      id: 'PROD-006',
      name: 'Queso Campesino 500g',
      barcode: '7708529631478',
      category: 'Lácteos',
      unit: 'un',
      totalAvailable: 18,
      inWarehouse: 6,
      onDisplay: 12,
      needsRestock: true,
    ),
  ];

  List<InventoryItem> get items => List.unmodifiable(_items);

  /// Adds a new product to inventory.
  void addProduct(InventoryItem newItem) {
    _items.insert(0, newItem);
    notifyListeners();
  }

  /// Decrements stock by 1 unit to manage sales.
  /// Returns false if there was no stock available to decrement.
  bool decrementUnit(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return false;

    final current = _items[index];
    if (current.totalAvailable <= 0) return false;

    // Deduct from display first, or from warehouse if display is empty
    int newDisplay = current.onDisplay;
    int newWarehouse = current.inWarehouse;

    if (newDisplay > 0) {
      newDisplay -= 1;
    } else if (newWarehouse > 0) {
      newWarehouse -= 1;
    }

    final newTotal = newDisplay + newWarehouse;
    final needsRestock = newTotal <= 20;

    _items[index] = current.copyWith(
      onDisplay: newDisplay,
      inWarehouse: newWarehouse,
      totalAvailable: newTotal,
      needsRestock: needsRestock,
    );

    notifyListeners();
    return true;
  }

  /// Increments stock by 1 unit (quick replenishment or incoming item).
  void incrementUnit(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final current = _items[index];
    final newDisplay = current.onDisplay + 1;
    final newTotal = newDisplay + current.inWarehouse;
    final needsRestock = newTotal <= 20;

    _items[index] = current.copyWith(
      onDisplay: newDisplay,
      totalAvailable: newTotal,
      needsRestock: needsRestock,
    );

    notifyListeners();
  }

  /// Deletes a product from the inventory list.
  void deleteProduct(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Adds stock from admission / receipt of merchandise.
  void addStockFromAdmission({
    required String name,
    required int quantity,
    required String unit,
    required String category,
  }) {
    final index = _items.indexWhere(
      (item) => item.name.trim().toLowerCase() == name.trim().toLowerCase(),
    );

    if (index != -1) {
      final current = _items[index];
      final newWarehouse = current.inWarehouse + quantity;
      final newTotal = newWarehouse + current.onDisplay;
      _items[index] = current.copyWith(
        inWarehouse: newWarehouse,
        totalAvailable: newTotal,
        needsRestock: newTotal <= 20,
      );
    } else {
      final newId = 'PROD-00${_items.length + 1}';
      final newItem = InventoryItem(
        id: newId,
        name: name,
        barcode: '770${DateTime.now().millisecondsSinceEpoch.toString().substring(3, 13)}',
        category: category,
        unit: unit,
        totalAvailable: quantity,
        inWarehouse: quantity,
        onDisplay: 0,
        needsRestock: false,
      );
      _items.insert(0, newItem);
    }
    notifyListeners();
  }
}
