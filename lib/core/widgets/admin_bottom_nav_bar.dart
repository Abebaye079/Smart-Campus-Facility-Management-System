import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/admin');
        break;
      case 1:
        context.go('/admin/manage');
        break;
      case 2:
        context.go('/admin/add');
        break;
      case 3:
        context.go('/admin/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      // 🔹 Forces labels to show and prevents "shifting" animation
      type: BottomNavigationBarType.fixed, 
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: const Color(0xFF9CA3AF),
      // 🔹 Ensures text is always rendered
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          activeIcon: Icon(Icons.list),
          label: "Manage",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle),
          label: "Add",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          activeIcon: Icon(Icons.admin_panel_settings),
          label: "Profile",
        ),
      ],
    );
  }
}