import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/main_header.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';
import '../../../../core/widgets/confirmation_dialog.dart'; // Your CustomDialog

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const MainHeaderWidget(),
            const SizedBox(height: 40),
            
            // Profile Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Abel Teshome",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "abel.tesh@university.edu",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "User",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Logout Button
            _buildActionButton(
              label: "Logout",
              color: const Color(0xFF2962FF), 
              onPressed: () => context.go(RouteNames.login),
            ),
            
            const SizedBox(height: 15),
            
            // Delete Account Button with Confirmation
            _buildActionButton(
              label: "Delete Account",
              color: const Color(0xFFFF5252),
              onPressed: () {
                CustomDialog.show(
                  context: context,
                  title: "Delete Account?",
                  message: "Are you sure you want to delete your account? This action cannot be undone.",
                  onConfirm: () {
                    Navigator.pop(context); // Close dialog
                    context.go(RouteNames.signup); // Navigate away
                  },
                );
              },
            ),
          ],
        ),
      ),
      // Positioned at the end of Scaffold
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildActionButton({required String label, required Color color, required VoidCallback onPressed}) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
