import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction.dart';
import '../../utils/transaction_helpers.dart';
import '../../constants/app_colors.dart';

class TransactionFormDialog extends StatefulWidget {
  final String type;
  final Transaction? transactionToEdit;
  final int? transactionKey;
  final DateTime? initialDate;

  const TransactionFormDialog({
    super.key,
    required this.type,
    this.transactionToEdit,
    this.transactionKey,
    this.initialDate,
  });

  @override
  State<TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.transactionToEdit?.amount.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.transactionToEdit?.description ?? '',
    );
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transactionToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing
                  ? (widget.type == 'income'
                      ? '✏️ Editar Ingreso'
                      : '✏️ Editar Gasto')
                  : (widget.type == 'income'
                      ? '💵 Agregar Ingreso'
                      : '💸 Agregar Gasto'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.type == 'income'
                    ? AppColors.income
                    : AppColors.expense,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Fecha: ${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_today,
                      color: AppColors.primary),
                  tooltip: 'Cambiar fecha',
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '0.00',
                prefixText: '\$ ',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Descripción (opcional)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancelar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final box =
                          await Hive.openBox<Transaction>('transactions');
                      final amount = double.tryParse(amountController.text);
                      if (amount != null && amount > 0) {
                        if (isEditing && widget.transactionKey != null) {
                          final updatedTransaction = Transaction(
                            amount: amount,
                            description: descriptionController.text.isEmpty
                                ? 'Sin descripción'
                                : descriptionController.text,
                            type: widget.type,
                            date: selectedDate,
                          );
                          box.put(widget.transactionKey!, updatedTransaction);
                          Navigator.pop(context);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '✅ Transacción actualizada: ${TransactionHelpers.formatCurrency(amount)}'),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          final transaction = Transaction(
                            amount: amount,
                            description: descriptionController.text.isEmpty
                                ? 'Sin descripción'
                                : descriptionController.text,
                            type: widget.type,
                            date: selectedDate,
                          );
                          box.add(transaction);
                          Navigator.pop(context);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(widget.type == 'income'
                                    ? '✅ Ingreso agregado: ${TransactionHelpers.formatCurrency(amount)}'
                                    : '✅ Gasto agregado: ${TransactionHelpers.formatCurrency(amount)}'),
                                backgroundColor: widget.type == 'income'
                                    ? AppColors.income
                                    : AppColors.expense,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('⚠️ Por favor ingresa un monto válido'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEditing ? 'Actualizar' : 'Confirmar',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
