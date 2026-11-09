import 'package:flutter/material.dart';
import 'package:nevara_emp/models/product_transfer.dart';

/// Presentational page for the product transfers module.
///
/// All state lives in [TransfersScreen]; this page only renders the data it
/// receives and reports user actions upward through callbacks.
class TransfersPage extends StatelessWidget {
  final List<ProductTransfer> transfers;
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final Function() onNewTransfer;

  static const Color darkBackground = Color(0xFF16181E);
  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color darkCardColor = Color(0xFF21252E);
  static const Color darkBorderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);
  static const Color secondaryTextColor = Color(0xFF94A3B8);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);

  const TransfersPage({
    super.key,
    required this.transfers,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onNewTransfer,
  });

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
              onPressed: () => onNewTransfer(),
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
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            onFilterSelected(filter);
                          }
                        },
                        selectedColor: emeraldBrand.withValues(alpha: 0.3),
                        backgroundColor: darkCardColor,
                        labelStyle: TextStyle(
                          color: isSelected ? activeGreen : secondaryTextColor,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
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
                                          color: statusColor.withValues(
                                              alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: statusColor.withValues(
                                                alpha: 0.5),
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
