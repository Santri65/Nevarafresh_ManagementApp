import 'package:flutter/material.dart';
import 'package:nevara_emp/models/product_transfer.dart';
import 'package:nevara_emp/pages/transfers_page.dart';

/// Screen presenting product transfers between NevaraFresh stores.
///
/// This screen owns the transfer list and the active filter. [TransfersPage]
/// receives the data and reports every user action back through callbacks.
class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
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

  void _onFilterSelected(String filter) {
    setState(() {
      _filter = filter;
    });
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  @override
  Widget build(BuildContext context) {
    return TransfersPage(
      transfers: _filteredTransfers,
      selectedFilter: _filter,
      onFilterSelected: _onFilterSelected,
      onNewTransfer: _showNewTransferDialog,
    );
  }
}
