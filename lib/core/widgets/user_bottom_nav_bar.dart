import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const UserBottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/facilities');
        break;
      case 2:
        context.go('/bookings');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      // 🔹 THIS LINE ENSURES LABELS ALWAYS SHOW
      type: BottomNavigationBarType.fixed, 
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: const Color(0xFF9CA3AF),
      // 🔹 THESE ENSURE THE FONT STYLES ARE CONSISTENT
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment_outlined),
          activeIcon: Icon(Icons.apartment),
          label: "Facilities",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: "Bookings",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}