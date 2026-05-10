import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/main_header.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // We call the MainHeader but pass the links into the 'trailing' slot
    return MainHeaderWidget(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLink(context, 'About Us', '/about'),
          const SizedBox(width: 12),
          _buildLink(context, 'FAQ', '/faq'),
        ],
      ),
    );
  }

  Widget _buildLink(BuildContext context, String label, String route) {
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