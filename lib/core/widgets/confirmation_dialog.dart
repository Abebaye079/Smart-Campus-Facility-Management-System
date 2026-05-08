import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isSuccess = false, // Default is false, so it won't break existing code
  }) {
    showDialog(
      context: context,
      barrierDismissible: !isSuccess, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: TextStyle(color: isSuccess ? AppColors.success : Colors.black)),
        content: Text(message),
        actions: [
          // Only show 'No' if it's a confirmation, hide it for Success
          if (!isSuccess)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No", style: TextStyle(color: Colors.grey)),
            ),
          TextButton(
            onPressed: onConfirm,
            child: Text(isSuccess ? "OK" : "Yes", 
              style: TextStyle(color: isSuccess ? AppColors.success : AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}