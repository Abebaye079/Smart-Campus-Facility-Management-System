import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final IconData? prefixIcon;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hint,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon ?? Icons.search),
        hintText: hint ?? "Search facilities...",
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
