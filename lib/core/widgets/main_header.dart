import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../constants/route_names.dart';

class MainHeaderWidget extends StatelessWidget {
  final bool showLinks;

  const MainHeaderWidget({
    super.key,
    this.showLinks = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: AppColors.primary, size: 36),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

          if (showLinks)
            Row(
              children: [
                _buildSmallLink(context, 'About Us', RouteNames.about),
                const SizedBox(width: 12),
                _buildSmallLink(context, 'FAQ', RouteNames.faq),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSmallLink(BuildContext context, String label, String route) {
    return InkWell(
      onTap: () => context.push(route),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}