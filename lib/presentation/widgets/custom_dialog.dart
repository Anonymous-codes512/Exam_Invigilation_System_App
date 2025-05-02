import 'package:flutter/material.dart';

// Enum to define dialog types
enum DialogType { success, warning, error }

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final DialogType dialogType;
  final VoidCallback onPressed;

  // Constructor to initialize the dialog's title, message, and type
  const CustomDialog({
    required this.title,
    required this.message,
    required this.dialogType,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Define icon, iconColor, and buttonColor based on dialog type
    IconData icon;
    Color iconColor;
    Color buttonColor;

    switch (dialogType) {
      case DialogType.success:
        icon = Icons.check_circle;
        iconColor = Colors.green;
        buttonColor = Colors.green;
        break;
      case DialogType.warning:
        icon = Icons.warning;
        iconColor = Colors.yellow;
        buttonColor = Colors.yellow;
        break;
      case DialogType.error:
        icon = Icons.cancel;
        iconColor = Colors.red;
        buttonColor = Colors.red;
        break;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      backgroundColor: Colors.white, // White background for the dialog
      elevation: 10, // Add shadow effect for the dialog
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Let content take minimum space
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title and Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 50), // Large Icon
                SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Message Text
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // Set button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
              onPressed: onPressed, // Call onPressed callback when pressed
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
