import 'package:flutter/material.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/facility_admin_card.dart';
import 'package:smart_campus_app/core/widgets/admin_bottom_nav_bar.dart';
import 'package:smart_campus_app/core/widgets/search_bar.dart';
import 'package:smart_campus_app/core/widgets/confirmation_dialog.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';

class ManageFacilitiesScreen extends StatefulWidget {
  const ManageFacilitiesScreen({super.key});

  @override
  State<ManageFacilitiesScreen> createState() => _ManageFacilitiesScreenState();
}

class _ManageFacilitiesScreenState extends State<ManageFacilitiesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allFacilities = [
    {
      "name": "Auditorium",
      "sub": "Main Block 5K",
      "cap": "300",
      "type": "Hall"
    },
    {"name": "Lab 101", "sub": "Technology Wing", "cap": "50", "type": "Lab"},
  ];

  List<Map<String, String>> _filteredFacilities = [];

  @override
  void initState() {
    super.initState();
    _filteredFacilities = _allFacilities;
    _searchController.addListener(() {
      _runFilter(_searchController.text);
    });
  }

  void _runFilter(String query) {
    setState(() {
      _filteredFacilities = _allFacilities
          .where((f) => f['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showStatus(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SearchBarWidget(controller: _searchController),
            ),
            const SizedBox(height: 20),
            const Text("Manage Facilities",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredFacilities.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredFacilities.length,
                      itemBuilder: (context, index) {
                        final item = _filteredFacilities[index];
                        return FacilityAdminCard(
                          name: item['name']!,
                          sub: item['sub']!,
                          cap: item['cap']!,
                          type: item['type']!,
                          onEdit: () => _showEdit(item, index),
                          onDelete: () => _showDelete(index),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No facilities match your search.")),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Icon(Icons.school, color: AppColors.primary, size: 40),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Smart Campus",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Facility Management",
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _showEdit(Map<String, String> data, int index) {
    final nameEdit = TextEditingController(text: data['name']);
    final capEdit = TextEditingController(text: data['cap']);
    final descEdit = TextEditingController(text: data['sub']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Facility Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(hint: "Name", controller: nameEdit),
            const SizedBox(height: 12),
            InputField(hint: "Capacity", controller: capEdit),
            const SizedBox(height: 12),
            InputField(hint: "Description", controller: descEdit),
            const SizedBox(height: 20),
            PrimaryButton(
                text: "Save Changes",
                onPressed: () {
                  setState(() {
                    // Actually updates the data
                    _allFacilities[index] = {
                      "name": nameEdit.text,
                      "sub": descEdit.text,
                      "cap": capEdit.text,
                      "type": data['type']!,
                    };
                    _runFilter(_searchController.text);
                  });
                  Navigator.pop(context);
                  _showStatus("Facility Updated Successfully!", Colors.green);
                }),
          ],
        ),
      ),
    );
  }

  void _showDelete(int index) {
    CustomDialog.show(
      context: context,
      title: "Delete Facility",
      message: "This will permanently remove this location from the system.",
      onConfirm: () {
        setState(() {
          _allFacilities.removeAt(index);
          _runFilter(_searchController.text);
        });
        Navigator.pop(context);
        _showStatus("Facility Deleted Successfully!", Colors.redAccent);
      },
    );
  }
}
