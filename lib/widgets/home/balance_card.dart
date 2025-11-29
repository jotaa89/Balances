import 'package:balances/utils/transaction_helpers.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'dart:ui';
import '../../constants/app_colors.dart';
import '../../models/transaction.dart';
import '../../utils/preferences.dart';


class BalanceCard extends StatelessWidget {
  final Box<Transaction> transactionBox;
  final VoidCallback onToggleVisibility;

  const BalanceCard({
    super.key,
    required this.transactionBox,
    required this.onToggleVisibility,
  });

  double calculateBalance() {
    double balance = 0;
    for (var transaction in transactionBox.values) {
      if (transaction.type == 'income') {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  Color getBalanceColor(double balance) {
    if (balance > 0) return AppColors.incomeLight;
    if (balance < 0) return AppColors.expenseLight;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),
      builder: (context, Box<Transaction> box, _) {
        final balance = calculateBalance();
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFa78bfa), Color(0xFF7c3aed)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Balance Total',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      AppPreferences.getShowBalance()
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: AppPreferences.getShowBalance()
                    ? Text(
                        TransactionHelpers.formatCurrency(balance),
                        key: const ValueKey('visible'),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: getBalanceColor(balance),
                        ),
                      )
                    : ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Text(
                          TransactionHelpers.formatCurrency(balance),
                          key: const ValueKey('hidden'),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: getBalanceColor(balance),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
