import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/constants/route_names.dart';

class AddFacilityScreen extends StatelessWidget {
  const AddFacilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // --- Header Section ---
                Row(
                  children: [
                    const Icon(Icons.school,
                        color: AppColors.primary, size: 40),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Smart Campus",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          "Facility Management",
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                const Text(
                  "Add Facility",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 30),

                // --- Input Card ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: AppColors.border.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        hintText: "Facility Name",
                        icon: Icons.account_balance_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        hintText: "Capacity",
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildDescriptionField(),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // --- Save Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push(RouteNames.manageFacilities),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Save  ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.save_outlined, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: 2, // Highlight the "Add" tab
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          if (index == 0) context.go(RouteNames.adminDashboard);
          if (index == 1) context.push(RouteNames.manageFacilities);
          if (index == 2) context.push(RouteNames.addFacility);
          if (index == 3) context.push(RouteNames.adminProfile);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_search_outlined), label: 'Manage'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // Helper widget for Facility Name and Capacity
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.black87),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  // Helper widget for the larger Description box
  Widget _buildDescriptionField() {
    return TextField(
      maxLines: 5,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "Description",
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 60.0),
          child: Icon(Icons.description_outlined, color: AppColors.border),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 40),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
