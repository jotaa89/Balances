import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final VoidCallback onClear;
  final Function(String) onSearchChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.query,
    required this.onClear,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '🔍 Buscar (separa con comas)...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        suffixIcon: query.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
            : null,
      ),
      onChanged: onSearchChanged,
    );
  }
}
