import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/manage_admin_header.dart';
import 'package:smart_campus_app/core/widgets/facility_admin_card.dart';
import 'package:smart_campus_app/core/widgets/admin_bottom_nav_bar.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/core/widgets/confirmation_dialog.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/presentation/providers/facility_provider.dart';

class ManageFacilitiesScreen extends ConsumerStatefulWidget {
  const ManageFacilitiesScreen({super.key});

  @override
  ConsumerState<ManageFacilitiesScreen> createState() =>
      _ManageFacilitiesScreenState();
}

class _ManageFacilitiesScreenState
    extends ConsumerState<ManageFacilitiesScreen> {
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

  // Handle Delete Confirmation using the provider
  void _showDeleteConfirmation(String id) {
    CustomDialog.show(
      context: context,
      title: "Confirm deletion?",
      message: "Are you sure you want to delete this item?",
      isDelete: true,
      cancelText: "Cancel",
      onConfirm: () async {
        Navigator.pop(context); // Close dialog
        try {
          await ref.read(facilityProvider.notifier).deleteFacility(id);
          _showStatus("Facility Deleted Successfully!", Colors.redAccent);
        } catch (e) {
          _showStatus("Failed to delete facility: $e", Colors.red);
        }
      },
    );
  }

  // Handle Edit Pop-up using the provider
  void _showEditPopUp(FacilityModel facility) {
    final nameEdit = TextEditingController(text: facility.name);
    final capEdit = TextEditingController(text: facility.capacity.toString());
    final descEdit = TextEditingController(text: facility.description);

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
              onPressed: () async {
                final updatedCapacity =
                    int.tryParse(capEdit.text) ?? facility.capacity;

                final updatedFacility = FacilityModel(
                  id: facility.id,
                  name: nameEdit.text,
                  capacity: updatedCapacity,
                  description: descEdit.text,
                  type: facility.type, // Maintain original type configuration
                );

                Navigator.pop(context); // Close dialog

                try {
                  await ref
                      .read(facilityProvider.notifier)
                      .updateFacility(updatedFacility);
                  _showStatus("Updated successfully!", Colors.green);
                } catch (e) {
                  _showStatus("Failed to update: $e", Colors.red);
                }
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
    final facilityState = ref.watch(facilityProvider);

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
              child: facilityState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    "Error loading facilities: $error",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                data: (facilities) {
                  if (facilities.isEmpty) {
                    return const Center(
                      child: Text("No facilities available."),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final item = facilities[index];
                      return FacilityAdminCard(
                        name: item.name,
                        sub: item.description,
                        cap: item.capacity.toString(),
                        type: item.type,
                        onEdit: () => _showEditPopUp(item),
                        onDelete: () => _showDeleteConfirmation(item.id),
                      );
                    },
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
