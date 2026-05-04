import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_names.dart';

class ManageFacilitiesScreen extends StatefulWidget {
  const ManageFacilitiesScreen({super.key});

  @override
  State<ManageFacilitiesScreen> createState() => _ManageFacilitiesScreenState();
}

class _ManageFacilitiesScreenState extends State<ManageFacilitiesScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // The master list of facilities as seen in photo_2026-05-04_18-39-37.jpg
  final List<Map<String, String>> _allFacilities = [
    {
      "name": "Auditorium",
      "sub": "Auditorium A",
      "cap": "300",
      "type": "Event Hall"
    },
    {
      "name": "Library",
      "sub": "Central Library",
      "cap": "500",
      "type": "Study"
    },
  ];

  // The list that updates based on search
  List<Map<String, String>> _filteredFacilities = [];

  @override
  void initState() {
    super.initState();
    _filteredFacilities = _allFacilities;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allFacilities;
    } else {
      results = _allFacilities
          .where((facility) =>
              facility["name"]!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              facility["sub"]!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredFacilities = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- Header Section with Search Toggle ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!_isSearching) ...[
                    Row(
                      children: [
                        const Icon(Icons.school,
                            color: AppColors.primary, size: 40),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Smart Campus",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text("Facility Management",
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ] else ...[
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "Search facilities...",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) => _runFilter(value),
                      ),
                    ),
                  ],
                  IconButton(
                    icon: Icon(_isSearching ? Icons.close : Icons.search,
                        size: 30, color: Colors.black87),
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                          _runFilter("");
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Manage Facilities",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // --- Facility List ---
            Expanded(
              child: _filteredFacilities.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredFacilities.length,
                      itemBuilder: (context, index) =>
                          _buildFacilityCard(_filteredFacilities[index]),
                    )
                  : const Center(child: Text("No facilities found.")),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFacilityCard(Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['name']!,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data['sub']!,
                    style: const TextStyle(color: AppColors.textSecondary)),
                Text("Capacity: ${data['cap']}",
                    style: const TextStyle(color: AppColors.textSecondary)),
                Text("Type: ${data['type']}",
                    style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            children: [
              _buildActionButton(
                  "Edit", Icons.edit_outlined, () => _showEditPopup(data)),
              const SizedBox(height: 10),
              _buildActionButton(
                  "Delete", Icons.delete_outline, () => _showDeletePopup()),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // --- POPUP: EDIT (photo_2026-05-05_00-17-11.jpg) ---
  void _showEditPopup(Map<String, String> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPopupField(data['sub']!, Icons.account_balance_outlined),
              const SizedBox(height: 12),
              _buildPopupField(data['cap']!, Icons.person_outline),
              const SizedBox(height: 12),
              _buildPopupField(data['type']!, Icons.description_outlined,
                  isLarge: true),
              const SizedBox(height: 20),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showStatusMessage("added successfully", Colors.green[100]!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Save ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Icon(Icons.save_outlined, color: Colors.white, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.black54)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- POPUP: DELETE (photo_2026-05-05_00-17-00.jpg) ---
  void _showDeletePopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("Confirm deletion?",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this item?",
            textAlign: TextAlign.center),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        actions: [
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showStatusMessage("deleted successfully", Colors.red[100]!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text("Delete",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.black87)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStatusMessage(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black)),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      duration: const Duration(seconds: 2),
    ));
  }

  Widget _buildPopupField(String initialValue, IconData icon,
      {bool isLarge = false}) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: isLarge ? 4 : 1,
      textAlign: isLarge ? TextAlign.center : TextAlign.start,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.border),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // "Manage" highlighted
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      onTap: (index) {
        if (index == 0) context.go(RouteNames.adminDashboard);
        if (index == 2) context.push(RouteNames.addFacility);
        if (index == 3) context.push(RouteNames.adminProfile);
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_search), label: 'Manage'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined), label: 'Add'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
