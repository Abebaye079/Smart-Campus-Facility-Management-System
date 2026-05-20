import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/admin_bottom_nav_bar.dart';
import 'package:smart_campus_app/core/widgets/main_header.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/presentation/providers/facility_provider.dart';

class AddFacilityScreen extends ConsumerStatefulWidget {
  const AddFacilityScreen({super.key});

  @override
  ConsumerState<AddFacilityScreen> createState() => _AddFacilityScreenState();
}

class _AddFacilityScreenState extends ConsumerState<AddFacilityScreen> {
  final _nameController = TextEditingController();
  final _capController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _capController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showStatus(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
      ),
    );
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Add Facility",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Input Card Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          InputField(
                            hint: "Facility Name",
                            controller: _nameController,
                            prefixIcon: Icons.domain_outlined,
                          ),
                          const SizedBox(height: 16),
                          InputField(
                            hint: "Capacity",
                            controller: _capController,
                            prefixIcon: Icons.people_outline,
                          ),
                          const SizedBox(height: 16),
                          InputField(
                            hint: "Description",
                            controller: _descController,
                            prefixIcon: Icons.description_outlined,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),

                    PrimaryButton(
                      text: "Save",
                      icon: Icons.save_outlined,
                      borderRadius: 28,
                      onPressed: () async {
                        // Validate inputs are not empty
                        if (_nameController.text.trim().isEmpty ||
                            _capController.text.trim().isEmpty) {
                          _showStatus(
                            "Please enter a name and capacity",
                            Colors.orange,
                          );
                          return;
                        }

                        final parsedCapacity =
                            int.tryParse(_capController.text.trim()) ?? 0;

                        final newFacility = FacilityModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text.trim(),
                          capacity: parsedCapacity,
                          description: _descController.text.trim(),
                          type: "Room",
                        );

                        try {
                          await ref
                              .read(facilityProvider.notifier)
                              .addFacility(newFacility);
                          _showStatus(
                            "Facility Added Successfully!",
                            Colors.green,
                          );

                          if (mounted) {
                            context.go(RouteNames.manageFacilities);
                          }
                        } catch (e) {
                          _showStatus("Failed to add facility: $e", Colors.red);
                        }
                      },
                    ),
                    const SizedBox(height: 40),
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
