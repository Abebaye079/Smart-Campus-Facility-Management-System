import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';

class FacilityCard extends StatelessWidget {
  final String name;
  final String capacity;
  final VoidCallback onBook;

  const FacilityCard({
    super.key,
    required this.name,
    required this.capacity,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Capacity: $capacity"),
            const SizedBox(height: 10),
            PrimaryButton(text: "Book Now", onPressed: onBook),
          ],
        ),
      ),
    );
  }
}