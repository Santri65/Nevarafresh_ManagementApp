import 'package:flutter/material.dart';
import 'package:nevara_emp/models/inventory_item.dart';

/// Presentational page for the store inventory module.
///
/// All state lives in [InventoryScreen]; this page only renders the data it
/// receives and reports user actions upward through callbacks.
class InventoryPage extends StatelessWidget {
  final List<InventoryItem> filteredItems;
  final String selectedCategory;
  final Function(String) onSearchChanged;
  final Function(String) onCategorySelected;
  final Function(InventoryItem) onSellUnit;
  final Function(InventoryItem) onAddUnit;
  final Function() onAddProduct;

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

  const InventoryPage({
    super.key,
    required this.filteredItems,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onSellUnit,
    required this.onAddUnit,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text('Inventario de Tienda'),
        centerTitle: false,
        backgroundColor: darkSurface,
        foregroundColor: primaryTextColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => onAddProduct(),
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldBrand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Agregar Producto',
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
              // Search input
              TextField(
                onChanged: (val) => onSearchChanged(val),
                style: const TextStyle(color: primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Buscar por producto o código de barras...',
                  hintStyle:
                      const TextStyle(color: secondaryTextColor, fontSize: 13),
                  prefixIcon:
                      const Icon(Icons.search, color: secondaryTextColor),
                  filled: true,
                  fillColor: darkCardColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: darkBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: activeGreen),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Categories horizontal filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Todas',
                    'Frutas y Verduras',
                    'Lácteos',
                    'Carnes',
                    'Granos y Abarrotes',
                    'Panadería',
                    'Aseo y Limpieza',
                  ].map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            onCategorySelected(category);
                          }
                        },
                        selectedColor: emeraldBrand.withValues(alpha: 0.3),
                        backgroundColor: darkCardColor,
                        labelStyle: TextStyle(
                          color: isSelected ? activeGreen : secondaryTextColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
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

              // Stock cards list with sell and add item operations
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron productos en el inventario.',
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: darkCardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: item.needsRestock
                                    ? warningOrange
                                    : darkBorderColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product header row
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                color: primaryTextColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.qr_code_rounded,
                                                  size: 14,
                                                  color: secondaryTextColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  item.barcode,
                                                  style: const TextStyle(
                                                    color: secondaryTextColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    item.category,
                                                    style: const TextStyle(
                                                      color: secondaryTextColor,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (item.needsRestock)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: warningOrange.withValues(
                                                alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: warningOrange.withValues(
                                                  alpha: 0.5),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.warning_amber_rounded,
                                                color: warningOrange,
                                                size: 12,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'Reponer',
                                                style: TextStyle(
                                                  color: warningOrange,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const Divider(
                                      color: darkBorderColor, height: 20),

                                  // Stock amounts breakdown
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _StockBadge(
                                        label: 'Disponible',
                                        value:
                                            '${item.totalAvailable} ${item.unit}',
                                        color: item.totalAvailable > 0
                                            ? activeGreen
                                            : dangerCoral,
                                      ),
                                      _StockBadge(
                                        label: 'En Bodega',
                                        value: '${item.inWarehouse} ${item.unit}',
                                        color: primaryTextColor,
                                      ),
                                      _StockBadge(
                                        label: 'En Exhibición',
                                        value: '${item.onDisplay} ${item.unit}',
                                        color: primaryTextColor,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Sales and stock adjustment actions bar
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: darkBorderColor),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Administrar ventas / Stock:',
                                          style: TextStyle(
                                            color: secondaryTextColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        // Vender (-1)
                                        OutlinedButton.icon(
                                          onPressed: item.totalAvailable > 0
                                              ? () => onSellUnit(item)
                                              : null,
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: dangerCoral,
                                            side: BorderSide(
                                              color: item.totalAvailable > 0
                                                  ? dangerCoral.withValues(
                                                      alpha: 0.6)
                                                  : Colors.white12,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          icon: const Icon(Icons.remove,
                                              size: 14),
                                          label: const Text(
                                            'Vender -1',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Agregar (+1)
                                        ElevatedButton.icon(
                                          onPressed: () => onAddUnit(item),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: emeraldBrand,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          icon: const Icon(Icons.add, size: 14),
                                          label: const Text(
                                            'Agregar +1',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
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

class _StockBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StockBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
