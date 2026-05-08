import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/admin_bottom_nav_bar.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/core/widgets/back_button.dart';
import 'package:smart_campus_app/core/widgets/main_header.dart';

class AddFacilityScreen extends StatefulWidget {
  const AddFacilityScreen({super.key});

  @override
  State<AddFacilityScreen> createState() => _AddFacilityScreenState();
}

class _AddFacilityScreenState extends State<AddFacilityScreen> {
  final nameController = TextEditingController();
  final capController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const MainHeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackButtonWidget(onTap: () => context.go('/admin/manage')),
                    const SizedBox(height: 20),
                    const Text(
                      "Add New Facility",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Register a new building or room in the system.",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 30),
                    InputField(hint: "Facility Name", controller: nameController),
                    const SizedBox(height: 20),
                    InputField(hint: "Capacity (Number)", controller: capController),
                    const SizedBox(height: 20),
                    InputField(
                      hint: "Description / Building",
                      controller: descController,
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: "Save Facility",
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Facility Added Successfully!"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        context.go('/admin/manage');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }
}
