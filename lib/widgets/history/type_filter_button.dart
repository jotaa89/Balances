import 'package:flutter/material.dart';
import '../common/filter_option.dart';

class TypeFilterButton extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  const TypeFilterButton({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilterOption(
            label: 'Todos',
            icon: Icons.list,
            value: 'all',
            isSelected: selectedType == 'all',
            onTap: () => onChanged('all'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilterOption(
            label: 'Ingresos',
            emoji: '💵',
            value: 'income',
            isSelected: selectedType == 'income',
            onTap: () => onChanged('income'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilterOption(
            label: 'Gastos',
            emoji: '🐜',
            value: 'expense',
            isSelected: selectedType == 'expense',
            onTap: () => onChanged('expense'),
          ),
        ),
      ],
    );
  }
}
