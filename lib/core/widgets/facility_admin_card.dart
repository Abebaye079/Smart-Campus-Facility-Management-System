import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FacilityAdminCard extends StatelessWidget {
  final String name;
  final String sub;
  final String cap;
  final String type;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FacilityAdminCard({
    super.key,
    required this.name,
    required this.sub,
    required this.cap,
    required this.type,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  "Capacity: $cap",
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  "Type: $type",
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildSmallButton("Edit", Icons.edit_outlined, onEdit),
              const SizedBox(height: 10),
              _buildSmallButton("Delete", Icons.delete_outline, onDelete),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        // 🧠 Explicit execution call closure
        onPressed: () => onTap(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
