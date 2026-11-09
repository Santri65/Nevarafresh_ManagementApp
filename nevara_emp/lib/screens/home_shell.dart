import 'package:flutter/material.dart';
import 'package:nevara_emp/components/app_navigation_rail.dart';
import 'package:nevara_emp/screens/incidents_screen.dart';
import 'package:nevara_emp/screens/inventory_screen.dart';
import 'package:nevara_emp/screens/profile_screen.dart';
import 'package:nevara_emp/screens/tasks_screen.dart';
import 'package:nevara_emp/screens/transfers_screen.dart';

/// Main responsive shell providing vertical left-side navigation for store operations.
class HomeShell extends StatefulWidget {
  final int initialIndex;

  const HomeShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _currentIndex;
  bool _isExtended = false;
  bool _hasCheckedLayout = false;

  static const Color darkBackground = Color(0xFF16181E);

  List<Widget> get _screens => [
    InventoryScreen(onBackToProfile: _goToProfile),
    IncidentsScreen(onBackToProfile: _goToProfile),
    TransfersScreen(onBackToProfile: _goToProfile),
    TasksScreen(onBackToProfile: _goToProfile),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToProfile() {
    setState(() {
      _currentIndex = 4;
    });
  }

  void _toggleExtended() {
    setState(() {
      _isExtended = !_isExtended;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Automatically default to extended on wide desktop screens
        if (!_hasCheckedLayout) {
          _isExtended = constraints.maxWidth >= 900;
          _hasCheckedLayout = true;
        }

        return Scaffold(
          backgroundColor: darkBackground,
          body: SafeArea(
            child: Row(
              children: [
                // Navigation bar on the left side
                AppNavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onDestinationSelected,
                  isExtended: _isExtended,
                  onToggleExtended: _toggleExtended,
                ),

                // Main screen view area
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
