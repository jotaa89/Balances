import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../widgets/home/balance_card.dart';
import '../widgets/home/action_buttons.dart';
import '../widgets/home/floating_nav.dart';
import '../widgets/dialogs/transaction_form.dart';
import '../widgets/dialogs/tips_dialog.dart';
import '../widgets/history/transaction_history_dialog.dart';
import '../utils/preferences.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Transaction> transactionBox;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<Transaction>('transactions');
    print('🔧 Box inicializado con ${transactionBox.length} transacciones');
  }

  void showTransactionDialog(String type,
    {Transaction? transactionToEdit, int? transactionKey, DateTime? initialDate}) {
  showDialog(
    context: context,
    builder: (context) => TransactionFormDialog(
      type: type,
      transactionToEdit: transactionToEdit,
      transactionKey: transactionKey,
      initialDate: initialDate,
    ),
  );
}

  void showTipsDialog() {
    showDialog(context: context, builder: (context) => const TipsDialog());
  }

  void showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => TransactionHistoryDialog(
        onAddTransaction: showTransactionDialog,
      ),
    );
  }

  void _toggleBalanceVisibility() {
    setState(() {
      final newValue = !AppPreferences.getShowBalance();
      AppPreferences.setShowBalance(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '💰 Control de Gastos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    BalanceCard(
                      transactionBox: transactionBox,
                      onToggleVisibility: _toggleBalanceVisibility,
                    ),
                    const SizedBox(height: 24),
                    ActionButtons(
                        onShowTransactionDialog: showTransactionDialog),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: showHistoryDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '📊 Ver Historial',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: const FloatingNavButton(),
    );
  }
}
