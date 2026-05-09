import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;

  final IconData? prefixIcon;
  final int maxLines;

  const InputField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
