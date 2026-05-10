import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MainHeaderWidget extends StatelessWidget {
  // 1. Define the optional slot
  final Widget? trailing; 

  const MainHeaderWidget({super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Always shows Logo and Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.school, color: AppColors.primary, size: 36),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Smart Campus',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  Text(
                    'Facility Management',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Right Side: ONLY shows content if 'trailing' is not null
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}