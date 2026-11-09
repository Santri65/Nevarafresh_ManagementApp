import 'package:flutter/material.dart';
import 'package:nevara_emp/models/inventory_item.dart';
import 'package:nevara_emp/models/inventory_repository.dart';

/// Screen presenting the store inventory management module.
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

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
  static const Color dangerCoral = Color(0xFFFF8A80);

  String _searchQuery = '';
  String _selectedCategory = 'Todas';

  final InventoryRepository _repository = InventoryRepository.instance;

  @override
  void initState() {
    super.initState();
    _repository.addListener(_onRepositoryUpdated);
  }

  @override
  void dispose() {
    _repository.removeListener(_onRepositoryUpdated);
    super.dispose();
  }

  void _onRepositoryUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  List<InventoryItem> get _filteredItems {
    return _repository.items.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.barcode.contains(_searchQuery);
      final matchesCategory = _selectedCategory == 'Todas' || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _handleSellUnit(InventoryItem item) {
    final success = _repository.decrementUnit(item.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Venta registrada: -1 ${item.unit} de ${item.name}'),
          backgroundColor: const Color(0xFF1B1F27),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No hay existencias disponibles para vender "${item.name}".'),
          backgroundColor: dangerCoral,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleAddUnit(InventoryItem item) {
    _repository.incrementUnit(item.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Existencia agregada: +1 ${item.unit} a ${item.name}'),
        backgroundColor: const Color(0xFF1B1F27),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final barcodeController = TextEditingController();
    final warehouseController = TextEditingController(text: '10');
    final displayController = TextEditingController(text: '10');
    String selectedCategory = 'Frutas y Verduras';
    String selectedUnit = 'un';

    final categories = [
      'Frutas y Verduras',
      'Lácteos',
      'Carnes',
      'Granos y Abarrotes',
      'Panadería',
      'Aseo y Limpieza',
    ];

    final units = ['un', 'kg', 'g', 'litro', 'paquete'];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: darkSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: darkBorderColor),
              ),
              title: const Row(
                children: [
                  Icon(Icons.add_box_rounded, color: activeGreen),
                  SizedBox(width: 8),
                  Text(
                    'Agregar Nuevo Producto',
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
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: primaryTextColor),
                      decoration: InputDecoration(
                        labelText: 'Nombre del producto',
                        labelStyle: const TextStyle(color: secondaryTextColor),
                        hintText: 'ej. Aguacate Hass',
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
                      controller: barcodeController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: primaryTextColor),
                      decoration: InputDecoration(
                        labelText: 'Código de barras',
                        labelStyle: const TextStyle(color: secondaryTextColor),
                        hintText: 'ej. 7701234567890',
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Categoría:',
                                style: TextStyle(color: secondaryTextColor, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: darkCardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: darkBorderColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedCategory,
                                    isExpanded: true,
                                    dropdownColor: darkSurface,
                                    style: const TextStyle(color: primaryTextColor, fontSize: 13),
                                    items: categories.map((cat) {
                                      return DropdownMenuItem(value: cat, child: Text(cat, overflow: TextOverflow.ellipsis));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setDialogState(() => selectedCategory = val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Unidad:',
                                style: TextStyle(color: secondaryTextColor, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: darkCardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: darkBorderColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedUnit,
                                    isExpanded: true,
                                    dropdownColor: darkSurface,
                                    style: const TextStyle(color: primaryTextColor, fontSize: 13),
                                    items: units.map((u) {
                                      return DropdownMenuItem(value: u, child: Text(u));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setDialogState(() => selectedUnit = val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: warehouseController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: primaryTextColor),
                            decoration: InputDecoration(
                              labelText: 'En Bodega',
                              labelStyle: const TextStyle(color: secondaryTextColor, fontSize: 12),
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
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: displayController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: primaryTextColor),
                            decoration: InputDecoration(
                              labelText: 'En Exhibición',
                              labelStyle: const TextStyle(color: secondaryTextColor, fontSize: 12),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar', style: TextStyle(color: secondaryTextColor)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    final barcode = barcodeController.text.trim().isNotEmpty
                        ? barcodeController.text.trim()
                        : '770${DateTime.now().millisecondsSinceEpoch.toString().substring(4, 13)}';

                    final warehouse = int.tryParse(warehouseController.text.trim()) ?? 0;
                    final display = int.tryParse(displayController.text.trim()) ?? 0;
                    final total = warehouse + display;

                    final newItem = InventoryItem(
                      id: 'PROD-00${_repository.items.length + 1}',
                      name: name,
                      barcode: barcode,
                      category: selectedCategory,
                      unit: selectedUnit,
                      totalAvailable: total,
                      inWarehouse: warehouse,
                      onDisplay: display,
                      needsRestock: total <= 20,
                    );

                    _repository.addProduct(newItem);
                    Navigator.pop(ctx);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Producto "$name" agregado al inventario.'),
                        backgroundColor: darkSurface,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldBrand,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Guardar Producto'),
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
    final filtered = _filteredItems;

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
              onPressed: _showAddProductDialog,
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

              // Stock cards list with sell and add item operations
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
                                  // Product header row
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

                                  // Stock amounts breakdown
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _StockBadge(
                                        label: 'Disponible',
                                        value: '${item.totalAvailable} ${item.unit}',
                                        color: item.totalAvailable > 0 ? activeGreen : dangerCoral,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: darkBorderColor),
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
                                              ? () => _handleSellUnit(item)
                                              : null,
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: dangerCoral,
                                            side: BorderSide(
                                              color: item.totalAvailable > 0
                                                  ? dangerCoral.withValues(alpha: 0.6)
                                                  : Colors.white12,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          icon: const Icon(Icons.remove, size: 14),
                                          label: const Text(
                                            'Vender -1',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Agregar (+1)
                                        ElevatedButton.icon(
                                          onPressed: () => _handleAddUnit(item),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: emeraldBrand,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          icon: const Icon(Icons.add, size: 14),
                                          label: const Text(
                                            'Agregar +1',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
