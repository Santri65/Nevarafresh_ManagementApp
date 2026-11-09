import 'package:flutter/material.dart';

/// Item representing a product in store inventory according to the MER model.
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
}

/// Screen presenting the store inventory management module.
class InventoryScreen extends StatefulWidget {
  final VoidCallback? onBackToProfile;

  const InventoryScreen({
    super.key,
    this.onBackToProfile,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  static const Color darkBackground = Color(0xFF16181E);
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);
  static const Color warningOrange = Color(0xFFFFB74D);

  String _searchQuery = '';
  String _selectedCategory = 'Todas';

  final List<InventoryItem> _items = const [
    InventoryItem(
      id: 'PROD-001',
      name: 'Manzana Royal Gala',
      barcode: '7701234567891',
      category: 'Frutas y Verduras',
      unit: 'kg',
      totalAvailable: 85,
      inWarehouse: 50,
      onDisplay: 35,
    ),
    InventoryItem(
      id: 'PROD-002',
      name: 'Leche Entera 1L',
      barcode: '7709876543210',
      category: 'Lácteos',
      unit: 'un',
      totalAvailable: 120,
      inWarehouse: 80,
      onDisplay: 40,
    ),
    InventoryItem(
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
    InventoryItem(
      id: 'PROD-004',
      name: 'Pechuga de Pollo Fresca',
      barcode: '7706549873215',
      category: 'Carnes',
      unit: 'kg',
      totalAvailable: 45,
      inWarehouse: 25,
      onDisplay: 20,
    ),
    InventoryItem(
      id: 'PROD-005',
      name: 'Arroz Blanco Especial 1kg',
      barcode: '7703216549872',
      category: 'Granos y Abarrotes',
      unit: 'un',
      totalAvailable: 210,
      inWarehouse: 150,
      onDisplay: 60,
    ),
    InventoryItem(
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

  List<InventoryItem> get _filteredItems {
    return _items.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.barcode.contains(_searchQuery);
      final matchesCategory = _selectedCategory == 'Todas' || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Inventario de Tienda'),
        centerTitle: false,
        backgroundColor: darkSurface,
        foregroundColor: primaryTextColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: widget.onBackToProfile ??
                () => Navigator.maybePop(context),
            tooltip: 'Regresar',
            icon: const Icon(Icons.arrow_back_rounded),
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
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: const TextStyle(color: primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Buscar por producto o código de barras...',
                  hintStyle: const TextStyle(color: secondaryTextColor, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: secondaryTextColor),
                  filled: true,
                  fillColor: darkCardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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

              // Categories row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Todas',
                    'Frutas y Verduras',
                    'Lácteos',
                    'Carnes',
                    'Granos y Abarrotes',
                  ].map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          }
                        },
                        selectedColor: emeraldBrand.withValues(alpha: 0.3),
                        backgroundColor: darkCardColor,
                        labelStyle: TextStyle(
                          color: isSelected ? activeGreen : secondaryTextColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

              // Stock cards list
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron productos en el inventario.',
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: darkCardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: item.needsRestock ? warningOrange : darkBorderColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    borderRadius: BorderRadius.circular(4),
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
                                            color: warningOrange.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: warningOrange.withValues(alpha: 0.5),
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
                                  const Divider(color: darkBorderColor, height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _StockBadge(
                                        label: 'Disponible',
                                        value: '${item.totalAvailable} ${item.unit}',
                                        color: activeGreen,
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
