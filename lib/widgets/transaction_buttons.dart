import 'package:flutter/material.dart';

class TransactionButtons extends StatelessWidget {
  final VoidCallback onExpenseTap;
  final VoidCallback onIncomeTap;

  const TransactionButtons({
    super.key,
    required this.onExpenseTap,
    required this.onIncomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onExpenseTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFFef4444),
                width: 3,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Column(
              children: [
                Text('🐜', style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(
                  'Gastos',
                  style: TextStyle(
                    color: Color(0xFFef4444),
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
            onPressed: onIncomeTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFF10b981),
                width: 3,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Column(
              children: [
                Text('💵', style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(
                  'Ingresos',
                  style: TextStyle(
                    color: Color(0xFF10b981),
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
