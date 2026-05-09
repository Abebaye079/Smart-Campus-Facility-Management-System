import 'package:flutter/material.dart';

class CustomDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = "Yes",
    String cancelText = "No",
    
    bool isDelete = false, 
    bool isBookingCancel = false,
  }) {
    showDialog(
      context: context,
      
      barrierDismissible: !isBookingCancel,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              
              // Layout Decision Logic
              if (isBookingCancel)
                _buildHorizontalLayout(context, onConfirm, confirmText, cancelText)
              else
                _buildVerticalLayout(context, onConfirm, confirmText, cancelText, isDelete),
            ],
          ),
        ),
      ),
    );
  }

  
  static Widget _buildHorizontalLayout(BuildContext context, VoidCallback onConfirm, String confirm, String cancel) {
    return Row(
      children: [
        Expanded(
          child: _dialogButton(
            text: cancel,
            color: const Color(0xFF2563EB), // Primary Blue
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _dialogButton(
            text: confirm,
            color: const Color(0xFFEF4444), // Danger Red
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }

  
  static Widget _buildVerticalLayout(BuildContext context, VoidCallback onConfirm, String confirm, String cancel, bool isDelete) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _dialogButton(
            text: isDelete ? "Delete" : confirm,
            color: isDelete ? const Color(0xFFEF4444) : const Color(0xFF2563EB),
            onPressed: onConfirm,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(cancel, style: const TextStyle(color: Colors.black54, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  static Widget _dialogButton({required String text, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}