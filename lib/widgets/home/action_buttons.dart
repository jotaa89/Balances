import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';



class ActionButtons extends StatelessWidget {
  final Function(String) onShowTransactionDialog;

  const ActionButtons({
    super.key,
    required this.onShowTransactionDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => onShowTransactionDialog('expense'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.expense, width: 3),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Column(
              children: [
                Text('🐜', style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(
                  'Gastos',
                  style: TextStyle(
                    color: AppColors.expense,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () => onShowTransactionDialog('income'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.income, width: 3),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Column(
              children: [
                Text('💵', style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(
                  'Ingresos',
                  style: TextStyle(
                    color: AppColors.income,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
