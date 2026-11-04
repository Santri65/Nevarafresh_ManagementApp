import 'package:flutter/material.dart';

/// Card showing store details and employee contact info conforming to the MER.
class StoreInfoCard extends StatelessWidget {
  final String storeName;
  final String storeCode;
  final String storeAddress;
  final String email;

  const StoreInfoCard({
    super.key,
    required this.storeName,
    required this.storeCode,
    required this.storeAddress,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.store, color: Color(0xFF2E7D32), size: 20),
                SizedBox(width: 8),
                Text(
                  'Sede y Contacto Corporativo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B2A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.business_outlined,
                  size: 20,
                  color: Color(0xFF5B5E72),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tienda asignada',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF757575),
                      ),
                    ),
                    Text(
                      '$storeName ($storeCode)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B1B2A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Color(0xFF5B5E72),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dirección de sede',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF757575),
                      ),
                    ),
                    Text(
                      storeAddress,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1B1B2A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 20,
                  color: Color(0xFF5B5E72),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Correo electrónico',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF757575),
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1B1B2A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
