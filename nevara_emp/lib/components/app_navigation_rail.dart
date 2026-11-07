import 'package:flutter/material.dart';

/// Reusable left navigation bar component using [NavigationRail].
///
/// Disposes navigation destinations vertically on the left side of the screen
/// and notifies the parent shell when an item is selected.
class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isExtended;
  final VoidCallback onToggleExtended;

  static const Color darkSurface = Color(0xFF1B1F27);
  static const Color activeGreen = Color(0xFF81C784);
  static const Color emeraldBrand = Color(0xFF0F8478);
  static const Color inactiveColor = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFF323744);
  static const Color primaryTextColor = Color(0xFFF1F5F9);

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.isExtended,
    required this.onToggleExtended,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: darkSurface,
        border: Border(
          right: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: NavigationRail(
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        extended: isExtended,
        minWidth: 72,
        minExtendedWidth: 210,
        labelType: isExtended
            ? NavigationRailLabelType.none
            : NavigationRailLabelType.all,
        indicatorColor: emeraldBrand.withValues(alpha: 0.25),
        selectedIconTheme: const IconThemeData(
          color: activeGreen,
          size: 24,
        ),
        unselectedIconTheme: const IconThemeData(
          color: inactiveColor,
          size: 24,
        ),
        selectedLabelTextStyle: const TextStyle(
          color: activeGreen,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: inactiveColor,
          fontSize: 11,
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: emeraldBrand.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shopping_basket_rounded,
                      color: activeGreen,
                      size: 22,
                    ),
                  ),
                  if (isExtended) ...[
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NevaraFresh',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Operación Tienda',
                          style: TextStyle(
                            color: inactiveColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: Icon(
                  isExtended
                      ? Icons.keyboard_double_arrow_left_rounded
                      : Icons.keyboard_double_arrow_right_rounded,
                  color: inactiveColor,
                  size: 20,
                ),
                tooltip: isExtended ? 'Contraer menú' : 'Expandir menú',
                onPressed: onToggleExtended,
              ),
            ],
          ),
        ),
        trailing: isExtended
            ? Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 14,
                        color: activeGreen,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Sede Centro (TDA-003)',
                        style: TextStyle(
                          color: inactiveColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: Text('Inventario'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.assignment_late_outlined),
            selectedIcon: Icon(Icons.assignment_late),
            label: Text('Reportes'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.swap_horiz_rounded),
            selectedIcon: Icon(Icons.swap_horizontal_circle),
            label: Text('Traslados'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: Text('Tareas'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: Text('Perfil'),
          ),
        ],
      ),
    );
  }
}
