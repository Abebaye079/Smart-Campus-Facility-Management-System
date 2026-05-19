import 'package:flutter/material.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/manage_admin_header.dart';
import 'package:smart_campus_app/core/widgets/facility_admin_card.dart';
import 'package:smart_campus_app/core/widgets/admin_bottom_nav_bar.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/core/widgets/confirmation_dialog.dart';

class ManageFacilitiesScreen extends StatefulWidget {
  const ManageFacilitiesScreen({super.key});

  @override
  State<ManageFacilitiesScreen> createState() => _ManageFacilitiesScreenState();
}

class _ManageFacilitiesScreenState extends State<ManageFacilitiesScreen> {
  final List<Map<String, String>> _allFacilities = [
    {
      "name": "Auditorium",
      "sub": "Main Block 5K",
      "cap": "300",
      "type": "Hall",
    },
    {"name": "Lab 101", "sub": "Technology Wing", "cap": "50", "type": "Lab"},
  ];

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

  // Handle Delete Confirmation
  void _showDeleteConfirmation(int index) {
    CustomDialog.show(
      context: context,
      title: "Confirm deletion?",
      message: "Are you sure you want to delete this item?",
      isDelete: true,
      cancelText: "Cancel", // Overrides the "No" default in the widget
      onConfirm: () {
        setState(() {
          _allFacilities.removeAt(index);
        });
        Navigator.pop(context);
        _showStatus("Facility Deleted Successfully!", Colors.redAccent);
      },
    );
  }

  // Handle Edit Pop-up
  void _showEditPopUp(Map<String, String> data) {
    final nameEdit = TextEditingController(text: data['name']);
    final capEdit = TextEditingController(text: data['cap']);
    final descEdit = TextEditingController(text: data['sub']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              hint: "Facility Name",
              controller: nameEdit,
              prefixIcon: Icons.domain_outlined,
            ),
            const SizedBox(height: 16),
            InputField(
              hint: "Capacity",
              controller: capEdit,
              prefixIcon: Icons.people_outline,
            ),
            const SizedBox(height: 16),
            InputField(
              hint: "Description",
              controller: descEdit,
              prefixIcon: Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: "Save",
              icon: Icons.save_outlined,
              borderRadius: 28,
              onPressed: () {
                Navigator.pop(context);
                _showStatus("Added successfully!", Colors.green);
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
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
            const ManageAdminHeader(),

            const SizedBox(height: 20),
            const Text(
              "Manage Facilities",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _allFacilities.length,
                itemBuilder: (context, index) {
                  final item = _allFacilities[index];
                  return FacilityAdminCard(
                    name: item['name']!,
                    sub: item['sub']!,
                    cap: item['cap']!,
                    type: item['type']!,
                    onEdit: () => _showEditPopUp(item),
                    onDelete: () => _showDeleteConfirmation(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }
}
