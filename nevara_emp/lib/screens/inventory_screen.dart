import 'package:flutter/material.dart';
import 'package:nevara_emp/models/inventory_item.dart';
import 'package:nevara_emp/models/inventory_repository.dart';
import 'package:nevara_emp/pages/inventory_page.dart';

/// Screen presenting the store inventory management module.
///
/// This screen owns the search state, the active category and the repository
/// listener. [InventoryPage] receives the filtered data and reports every user
/// action back through callbacks.
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);
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
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.barcode.contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == 'Todas' || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleSellUnit(InventoryItem item) {
    final success = _repository.decrementUnit(item.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Venta registrada: -1 ${item.unit} de ${item.name}'),
          backgroundColor: darkSurface,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'No hay existencias disponibles para vender "${item.name}".'),
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
        backgroundColor: darkSurface,
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
                                style: TextStyle(
                                    color: secondaryTextColor, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                    style: const TextStyle(
                                        color: primaryTextColor, fontSize: 13),
                                    items: categories.map((cat) {
                                      return DropdownMenuItem(
                                          value: cat,
                                          child: Text(cat,
                                              overflow:
                                                  TextOverflow.ellipsis));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setDialogState(
                                            () => selectedCategory = val);
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
                                style: TextStyle(
                                    color: secondaryTextColor, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                    style: const TextStyle(
                                        color: primaryTextColor, fontSize: 13),
                                    items: units.map((u) {
                                      return DropdownMenuItem(
                                          value: u, child: Text(u));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setDialogState(
                                            () => selectedUnit = val);
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
                              labelStyle: const TextStyle(
                                  color: secondaryTextColor, fontSize: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: darkBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: activeGreen),
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
                              labelStyle: const TextStyle(
                                  color: secondaryTextColor, fontSize: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: darkBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: activeGreen),
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
                  child: const Text('Cancelar',
                      style: TextStyle(color: secondaryTextColor)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    final barcode = barcodeController.text.trim().isNotEmpty
                        ? barcodeController.text.trim()
                        : '770${DateTime.now().millisecondsSinceEpoch.toString().substring(4, 13)}';

                    final warehouse =
                        int.tryParse(warehouseController.text.trim()) ?? 0;
                    final display =
                        int.tryParse(displayController.text.trim()) ?? 0;
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
                        content:
                            Text('Producto "$name" agregado al inventario.'),
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
    return InventoryPage(
      filteredItems: _filteredItems,
      selectedCategory: _selectedCategory,
      onSearchChanged: _onSearchChanged,
      onCategorySelected: _onCategorySelected,
      onSellUnit: _handleSellUnit,
      onAddUnit: _handleAddUnit,
      onAddProduct: _showAddProductDialog,
    );
  }
}
