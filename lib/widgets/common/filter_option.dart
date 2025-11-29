import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class FilterOption extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? emoji;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOption({
    super.key,
    required this.label,
    this.icon,
    this.emoji,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.black87,
              )
            else if (emoji != null)
              Text(
                emoji!,
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
