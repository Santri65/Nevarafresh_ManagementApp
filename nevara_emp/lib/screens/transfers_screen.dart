import 'package:flutter/material.dart';

/// Model representing a product transfer between stores.
class ProductTransfer {
  final String id;
  final String originStore;
  final String destinationStore;
  final String product;
  final String quantity;
  final String status;
  final String date;
  final String responsible;

  const ProductTransfer({
    required this.id,
    required this.originStore,
    required this.destinationStore,
    required this.product,
    required this.quantity,
    required this.status,
    required this.date,
    required this.responsible,
  });
}

/// Screen presenting product transfers between NevaraFresh stores.
class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  static const Color darkBackground = Color(0xFF16181E);
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);

  String _filter = 'Todos';

  final List<ProductTransfer> _transfers = [
    const ProductTransfer(
      id: 'TRS-201',
      originStore: 'Sede Principal Centro',
      destinationStore: 'Sede Norte',
      product: 'Aguacate Hass',
      quantity: '45 kg',
      status: 'En tránsito',
      date: '06/11/2026',
      responsible: 'Carlos Andrés Mendoza',
    ),
    const ProductTransfer(
      id: 'TRS-202',
      originStore: 'Sede Sur',
      destinationStore: 'Sede Principal Centro',
      product: 'Tomate Chonto',
      quantity: '80 kg',
      status: 'Recibido',
      date: '05/11/2026',
      responsible: 'Carlos Andrés Mendoza',
    ),
    const ProductTransfer(
      id: 'TRS-203',
      originStore: 'Sede Principal Centro',
      destinationStore: 'Sede Oeste',
      product: 'Leche Deslactosada 1L',
      quantity: '60 un',
      status: 'Pendiente',
      date: '05/11/2026',
      responsible: 'Carlos Andrés Mendoza',
    ),
    const ProductTransfer(
      id: 'TRS-204',
      originStore: 'Sede Valle del Lili',
      destinationStore: 'Sede Principal Centro',
      product: 'Pechuga de Pollo Fresca',
      quantity: '30 kg',
      status: 'Recibido',
      date: '04/11/2026',
      responsible: 'Carlos Andrés Mendoza',
    ),
    const ProductTransfer(
      id: 'TRS-205',
      originStore: 'Sede Principal Centro',
      destinationStore: 'Sede Sur',
      product: 'Arroz Blanco Especial 1kg',
      quantity: '120 un',
      status: 'En tránsito',
      date: '04/11/2026',
      responsible: 'Carlos Andrés Mendoza',
    ),
  ];

  List<ProductTransfer> get _filteredTransfers {
    if (_filter == 'Todos') {
      return _transfers;
    }
    return _transfers.where((item) => item.status == _filter).toList();
  }

  void _showNewTransferDialog() {
    final destinationController = TextEditingController();
    final productController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: darkBorderColor),
          ),
          title: const Row(
            children: [
              Icon(Icons.swap_horiz_rounded, color: activeGreen),
              SizedBox(width: 8),
              Text(
                'Solicitar Traslado',
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
                const Text(
                  'Tienda origen:',
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: darkCardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: darkBorderColor),
                  ),
                  child: const Text(
                    'Sede Principal Centro (TDA-003)',
                    style: TextStyle(color: primaryTextColor, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: destinationController,
                  style: const TextStyle(color: primaryTextColor),
                  decoration: InputDecoration(
                    labelText: 'Tienda destino',
                    labelStyle: const TextStyle(color: secondaryTextColor),
                    hintText: 'ej. Sede Norte (TDA-001)',
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
                  controller: productController,
                  style: const TextStyle(color: primaryTextColor),
                  decoration: InputDecoration(
                    labelText: 'Producto a trasladar',
                    labelStyle: const TextStyle(color: secondaryTextColor),
                    hintText: 'ej. Manzana Royal Gala',
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
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: primaryTextColor),
                  decoration: InputDecoration(
                    labelText: 'Cantidad y unidad',
                    labelStyle: const TextStyle(color: secondaryTextColor),
                    hintText: 'ej. 40 kg o 25 unidades',
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: secondaryTextColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (destinationController.text.trim().isNotEmpty &&
                    productController.text.trim().isNotEmpty) {
                  setState(() {
                    _transfers.insert(
                      0,
                      ProductTransfer(
                        id: 'TRS-${200 + _transfers.length + 1}',
                        originStore: 'Sede Principal Centro',
                        destinationStore: destinationController.text.trim(),
                        product: productController.text.trim(),
                        quantity: quantityController.text.trim().isNotEmpty
                            ? quantityController.text.trim()
                            : '1 un',
                        status: 'Pendiente',
                        date: '06/11/2026',
                        responsible: 'Carlos Andrés Mendoza',
                      ),
                    );
                  });
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldBrand,
                foregroundColor: Colors.white,
              ),
              child: const Text('Registrar Traslado'),
            ),
          ],
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Recibido':
        return activeGreen;
      case 'En tránsito':
        return const Color(0xFFFFB74D);
      case 'Pendiente':
      default:
        return const Color(0xFF64B5F6);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Recibido':
        return Icons.check_circle_outline_rounded;
      case 'En tránsito':
        return Icons.local_shipping_outlined;
      case 'Pendiente':
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transfers = _filteredTransfers;

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text('Traslado de Productos'),
        centerTitle: false,
        backgroundColor: darkSurface,
        foregroundColor: primaryTextColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: _showNewTransferDialog,
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
                'Solicitar Traslado',
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
              // Filter chips bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Todos',
                    'En tránsito',
                    'Pendiente',
                    'Recibido',
                  ].map((filter) {
                    final isSelected = _filter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _filter = filter;
                            });
                          }
                        },
                        selectedColor: emeraldBrand.withValues(alpha: 0.3),
                        backgroundColor: darkCardColor,
                        labelStyle: TextStyle(
                          color: isSelected ? activeGreen : secondaryTextColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
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

              // Transfers list
              Expanded(
                child: transfers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              size: 56,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No hay traslados en este estado',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Usa el botón "Solicitar Traslado" para crear uno.',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: transfers.length,
                        itemBuilder: (context, index) {
                          final item = transfers[index];
                          final statusColor = _statusColor(item.status);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: darkCardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: darkBorderColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                          color: statusColor.withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: statusColor.withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _statusIcon(item.status),
                                              size: 14,
                                              color: statusColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.status,
                                              style: TextStyle(
                                                color: statusColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Origen',
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                                fontSize: 11,
                                              ),
                                            ),
                                            Text(
                                              item.originStore,
                                              style: const TextStyle(
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: activeGreen,
                                        size: 18,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'Destino',
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                                fontSize: 11,
                                              ),
                                            ),
                                            Text(
                                              item.destinationStore,
                                              style: const TextStyle(
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: darkBorderColor,
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.inventory_2_outlined,
                                            size: 16,
                                            color: activeGreen,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${item.product} (${item.quantity})',
                                            style: const TextStyle(
                                              color: primaryTextColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        item.date,
                                        style: const TextStyle(
                                          color: secondaryTextColor,
                                          fontSize: 12,
                                        ),
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
