import 'package:eis/core/constants/AppColors.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onTap;

  const DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        height: 125, // Set fixed height for the card
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: AppColors.subtitleColor, blurRadius: 5)
              ],
            ),
            child: Row(
              children: [
                Icon(icon, size: 40, color: AppColors.primaryColor),
                SizedBox(width: 25),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
