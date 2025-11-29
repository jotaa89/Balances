// ============================================
// ARCHIVO: pubspec.yaml
// ============================================
/*
name: control_gastos
description: Aplicación de control de gastos personal

publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.0
  build_runner: ^2.4.6
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
*/

// ============================================
// ARCHIVO: lib/models/transaction.dart
// ============================================
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late double amount;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String type; // 'income' o 'expense'

  @HiveField(3)
  late DateTime date;

  Transaction({
    required this.amount,
    required this.description,
    required this.type,
    required this.date,
  });
}

// ============================================
// ARCHIVO: lib/main.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  // Registrar adaptador
  Hive.registerAdapter(TransactionAdapter());
  
  // Abrir box
  await Hive.openBox<Transaction>('transactions');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ============================================
// ARCHIVO: lib/screens/home_screen.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Transaction> transactionBox;
  bool showBalance = true;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<Transaction>('transactions');
  }

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
    if (balance > 0) return const Color(0xFF86efac);
    if (balance < 0) return const Color(0xFFfca5a5);
    return Colors.white;
  }

  void showTransactionDialog(String type) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type == 'income' ? '💵 Agregar Ingreso' : '💸 Agregar Gasto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: type == 'income'
                      ? const Color(0xFF10b981)
                      : const Color(0xFFef4444),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF764ba2), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Descripción (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF764ba2), width: 2),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final amount = double.tryParse(amountController.text);
                        if (amount != null && amount > 0) {
                          final transaction = Transaction(
                            amount: amount,
                            description: descriptionController.text.isEmpty
                                ? 'Sin descripción'
                                : descriptionController.text,
                            type: type,
                            date: DateTime.now(),
                          );
                          
                          print('💾 Guardando transacción: ${transaction.type} - \${transaction.amount}');
                          transactionBox.add(transaction);
                          print('✅ Transacciones totales en box: ${transactionBox.length}');
                          
                          Navigator.pop(context);
                          
                          // Mostrar confirmación
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                type == 'income' 
                                    ? '✅ Ingreso agregado: \${amount.toStringAsFixed(2)}'
                                    : '✅ Gasto agregado: \${amount.toStringAsFixed(2)}'
                              ),
                              backgroundColor: type == 'income' 
                                  ? const Color(0xFF10b981) 
                                  : const Color(0xFFef4444),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('⚠️ Por favor ingresa un monto válido'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF764ba2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTipsDialog() {
    final tips = [
      "Registra todos tus gastos diariamente para tener un control preciso",
      "Establece un presupuesto mensual y trata de no excederlo",
      "Ahorra al menos el 20% de tus ingresos cada mes",
      "Evita compras impulsivas, espera 24 horas antes de comprar algo costoso",
      "Revisa tus suscripciones y cancela las que no uses",
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '💡 Consejos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF764ba2),
                ),
              ),
              const SizedBox(height: 20),
              ...tips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Color(0xFF764ba2),
                            fontSize: 20,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF764ba2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => const HistoryDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF8B5CF6),
            ],
          ),
        ),
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
                    // Header
                    const Text(
                      '💰 Control de Gastos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF764ba2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Balance Card
                    ValueListenableBuilder(
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
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Balance Total',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: showBalance
                                        ? Text(
                                            '\$${balance.toStringAsFixed(2)}',
                                            key: const ValueKey('visible'),
                                            style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: getBalanceColor(balance),
                                            ),
                                          )
                                        : ImageFiltered(
                                            imageFilter: ImageFilter.blur(
                                              sigmaX: 10,
                                              sigmaY: 10,
                                            ),
                                            child: Text(
                                              '\$${balance.toStringAsFixed(2)}',
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
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showBalance = !showBalance;
                                    });
                                  },
                                  icon: Icon(
                                    showBalance
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => showTransactionDialog('expense'),
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
                            onPressed: () => showTransactionDialog('income'),
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
                    ),
                    const SizedBox(height: 16),

                    // History Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: showHistoryDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF764ba2),
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: showTipsDialog,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                'Consejos →',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// WIDGET PERSONALIZADO PARA FILTRO DE TIPO
// ============================================
class _TypeFilterButton extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  const _TypeFilterButton({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterOption(
            label: 'Todos',
            icon: Icons.list,
            value: 'all',
            isSelected: selectedType == 'all',
            onTap: () => onChanged('all'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterOption(
            label: 'Ingresos',
            emoji: '💵',
            value: 'income',
            isSelected: selectedType == 'income',
            onTap: () => onChanged('income'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterOption(
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

class _FilterOption extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? emoji;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
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
          color: isSelected ? const Color(0xFF764ba2) : Colors.grey[200],
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

// ============================================
// HISTORIAL CON FILTROS AVANZADOS
// ============================================
class HistoryDialog extends StatefulWidget {
  const HistoryDialog({super.key});

  @override
  State<HistoryDialog> createState() => _HistoryDialogState();
}

class _HistoryDialogState extends State<HistoryDialog> {
  String selectedPeriodFilter = 'daily';
  String selectedTypeFilter = 'all'; // 'all', 'income', 'expense'
  late Box<Transaction> transactionBox;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<Transaction>('transactions');
  }

  List<Transaction> getFilteredTransactions() {
    final now = DateTime.now();
    final transactions = transactionBox.values.toList();
    
    print('📊 Total transacciones en box: ${transactions.length}');

    // Filtrar por período
    final periodFiltered = transactions.where((transaction) {
      switch (selectedPeriodFilter) {
        case 'daily':
          return transaction.date.year == now.year &&
              transaction.date.month == now.month &&
              transaction.date.day == now.day;
        case 'weekly':
          final weekAgo = now.subtract(const Duration(days: 7));
          return transaction.date.isAfter(weekAgo);
        case 'monthly':
          return transaction.date.year == now.year &&
              transaction.date.month == now.month;
        case 'yearly':
          return transaction.date.year == now.year;
        default:
          return true;
      }
    }).toList();
    
    print('📅 Después de filtro de período ($selectedPeriodFilter): ${periodFiltered.length}');

    // Filtrar por tipo
    final typeFiltered = periodFiltered.where((transaction) {
      if (selectedTypeFilter == 'all') return true;
      return transaction.type == selectedTypeFilter;
    }).toList();
    
    print('🔍 Después de filtro de tipo ($selectedTypeFilter): ${typeFiltered.length}');
    
    if (typeFiltered.isNotEmpty) {
      print('✅ Primera transacción: ${typeFiltered.first.type} - \${typeFiltered.first.amount} - ${typeFiltered.first.description}');
    }

    typeFiltered.sort((a, b) => b.date.compareTo(a.date));
    return typeFiltered;
  }

  double calculateTotal(List<Transaction> transactions) {
    double total = 0;
    for (var transaction in transactions) {
      if (transaction.type == 'income') {
        total += transaction.amount;
      } else {
        total -= transaction.amount;
      }
    }
    return total;
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String getPeriodLabel() {
    switch (selectedPeriodFilter) {
      case 'daily':
        return 'Hoy';
      case 'weekly':
        return 'Esta Semana';
      case 'monthly':
        return 'Este Mes';
      case 'yearly':
        return 'Este Año';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700, maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📊 Historial',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF764ba2),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filtro de Tipo (Nuevo)
            Row(
              children: [
                Expanded(
                  child: _TypeFilterButton(
                    selectedType: selectedTypeFilter,
                    onChanged: (String newType) {
                      setState(() {
                        selectedTypeFilter = newType;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filtro de Período
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Diario'),
                  selected: selectedPeriodFilter == 'daily',
                  onSelected: (selected) {
                    setState(() => selectedPeriodFilter = 'daily');
                  },
                  selectedColor: const Color(0xFF764ba2),
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selectedPeriodFilter == 'daily'
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilterChip(
                  label: const Text('Semanal'),
                  selected: selectedPeriodFilter == 'weekly',
                  onSelected: (selected) {
                    setState(() => selectedPeriodFilter = 'weekly');
                  },
                  selectedColor: const Color(0xFF764ba2),
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selectedPeriodFilter == 'weekly'
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilterChip(
                  label: const Text('Mensual'),
                  selected: selectedPeriodFilter == 'monthly',
                  onSelected: (selected) {
                    setState(() => selectedPeriodFilter = 'monthly');
                  },
                  selectedColor: const Color(0xFF764ba2),
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selectedPeriodFilter == 'monthly'
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilterChip(
                  label: const Text('Anual'),
                  selected: selectedPeriodFilter == 'yearly',
                  onSelected: (selected) {
                    setState(() => selectedPeriodFilter = 'yearly');
                  },
                  selectedColor: const Color(0xFF764ba2),
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selectedPeriodFilter == 'yearly'
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Resumen
            ValueListenableBuilder(
              valueListenable: transactionBox.listenable(),
              builder: (context, Box<Transaction> box, _) {
                final filteredTransactions = getFilteredTransactions();
                final total = calculateTotal(filteredTransactions);
                
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF764ba2).withOpacity(0.1),
                        const Color(0xFFa78bfa).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF764ba2).withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        getPeriodLabel(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF764ba2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: total >= 0 
                              ? const Color(0xFF10b981) 
                              : const Color(0xFFef4444),
                        ),
                      ),
                      Text(
                        '${filteredTransactions.length} transacción${filteredTransactions.length != 1 ? 'es' : ''}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Lista de transacciones
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: transactionBox.listenable(),
                builder: (context, Box<Transaction> box, _) {
                  final filteredTransactions = getFilteredTransactions();

                  if (filteredTransactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay transacciones',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedTypeFilter == 'all'
                                ? 'en este período'
                                : selectedTypeFilter == 'income'
                                    ? 'de ingresos en este período'
                                    : 'de gastos en este período',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      final isIncome = transaction.type == 'income';

                      return Dismissible(
                        key: Key(transaction.key.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 32,
                          ),
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.red),
                                    ),
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
                                '🗑️ Transacción eliminada: \${transaction.amount.toStringAsFixed(2)}',
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Deshacer',
                                textColor: Colors.white,
                                onPressed: () {
                                  transactionBox.add(transaction);
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFF3E5F5),
                                Colors.white,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border(
                              left: BorderSide(
                                color: isIncome
                                    ? const Color(0xFF10b981)
                                    : const Color(0xFFef4444),
                                width: 4,
                              ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${isIncome ? '+' : '-'}\${transaction.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isIncome
                                          ? const Color(0xFF10b981)
                                          : const Color(0xFFef4444),
                                    ),
                                  ),
                                  Text(
                                    formatDate(transaction.date),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                transaction.description,
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        isIncome ? '💵' : '🐜',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isIncome ? 'Ingreso' : 'Gasto',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '← Desliza para eliminar',
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}