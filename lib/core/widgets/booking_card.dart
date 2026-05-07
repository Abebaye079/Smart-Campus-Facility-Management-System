import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/secondary_button.dart';
import 'package:smart_campus_app/core/widgets/destructive_button.dart';

class BookingCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const BookingCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(date),
            Text(time),
            Row(
              children: [
                SecondaryButton(text: "Edit", onPressed: onEdit),
                const SizedBox(width: 10),
                DangerButton(text: "Cancel", onPressed: onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
