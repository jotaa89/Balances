import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction.dart';
import '../../utils/transaction_helpers.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dialogs/transaction_form.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Box<Transaction> transactionBox;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.transactionBox,
  });

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _editTransaction(
      BuildContext context, Transaction transaction, int key) {
    showDialog(
      context: context,
      builder: (context) => TransactionFormDialog(
        type: transaction.type,
        transactionToEdit: transaction,
        transactionKey: key,
        
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('No hay transacciones',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              const SizedBox(height: 8),
              Text('en este período',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final transactionKey = transactionBox.keys.firstWhere(
          (key) => transactionBox.get(key) == transaction,
        );
        final isIncome = transaction.type == 'income';

        return Dismissible(
          key: Key(transactionKey.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 32),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content: const Text(
                      '¿Estás seguro de que quieres eliminar esta transacción?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Eliminar',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            transaction.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '🗑️ Transacción eliminada: ${TransactionHelpers.formatCurrency(transaction.amount)}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: InkWell(
            onTap: () =>
                _editTransaction(context, transaction, transactionKey as int),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    isIncome
                        ? AppColors.income.withOpacity(0.05)
                        : AppColors.expense.withOpacity(0.05),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.15],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isIncome
                      ? AppColors.income.withOpacity(0.3)
                      : AppColors.expense.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'}${TransactionHelpers.formatCurrency(transaction.amount)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isIncome ? AppColors.income : AppColors.expense,
                        ),
                      ),
                      Text(
                        formatDate(transaction.date),
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transaction.description,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(isIncome ? '💵' : '🐜',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            isIncome ? 'Ingreso' : 'Gasto',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.edit, size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            'Tap para editar',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '← Desliza para borrar',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
