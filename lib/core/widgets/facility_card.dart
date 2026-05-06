import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';

class FacilityCard extends StatelessWidget {
  final String name;
  final String capacity;
  final VoidCallback onBook;
  final VoidCallback onTap;

  const FacilityCard({
    super.key,
    required this.name,
    required this.capacity,
    required this.onBook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Capacity: $capacity",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: "Book Now",
                  onPressed: onBook,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}