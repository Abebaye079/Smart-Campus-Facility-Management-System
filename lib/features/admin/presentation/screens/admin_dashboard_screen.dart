import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/admin_bottom_nav_bar.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 30),
              const Text("Welcome, Israel",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Manage your campus facilities efficiently.",
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 30),
              _buildStatGrid(),
              const SizedBox(height: 40),
              const Text("Quick Actions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              PrimaryButton(
                text: "Manage All Facilities",
                onPressed: () => context.go('/admin/manage'),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: "Add New Facility",
                onPressed: () => context.go('/admin/add'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.school, color: AppColors.primary, size: 40),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Smart Campus",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("Admin Dashboard",
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ],
        ),
        const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white)),
      ],
    );
  }

  Widget _buildStatGrid() {
    return Row(
      children: [
        _buildStatBox("Facilities", "12", Icons.business),
        const SizedBox(width: 16),
        _buildStatBox("Requests", "5", Icons.pending_actions),
      ],
    );
  }

  Widget _buildStatBox(String label, String val, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ]),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 30),
            const SizedBox(height: 8),
            Text(val,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
