import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/main_header.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';
import '../../../../core/widgets/confirmation_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State to control the visibility of the success banner
  bool _showSuccessBanner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                        "Hana Tesfaye",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "hana.tesfaye@university.edu",
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
                
                // Delete Account Button
                _buildActionButton(
                  label: "Delete Account",
                  color: const Color(0xFFFF5252),
                  onPressed: () {
                    CustomDialog.show(
                      context: context,
                      title: "Confirm deletion?",
                      message: "Are you sure you want to delete your account?",
                      isDelete: true, 
                      cancelText: "Cancel",
                      onConfirm: () {
                        // 1. Close Dialog
                        Navigator.pop(context); 
                        
                        // 2. Show Success Banner
                        setState(() {
                          _showSuccessBanner = true;
                        });

                        // 3. Wait 2 seconds, then navigate away
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            context.go(RouteNames.splash);
                          }
                        });
                      },
                    );
                  },
                ),
              ],
            ),

            if (_showSuccessBanner)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9999), // Light red/coral from image
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Deleted Successfully!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
