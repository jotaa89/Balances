import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction.dart';
import '../../utils/transaction_helpers.dart';
import '../../constants/app_colors.dart';
import 'filter_panel.dart';
import 'custom_search_bar.dart';
import 'transaction_list.dart';
import '../dialogs/year_picker.dart';
import '../dialogs/month_picker.dart';
import '../dialogs/week_picker.dart';

class TransactionHistoryDialog extends StatefulWidget {
  final Function(String, {DateTime? initialDate}) onAddTransaction;

  const TransactionHistoryDialog({super.key, required this.onAddTransaction});

  @override
  State<TransactionHistoryDialog> createState() =>
      _TransactionHistoryDialogState();
}

class _TransactionHistoryDialogState extends State<TransactionHistoryDialog> {
  String selectedPeriodFilter = 'daily';
  String selectedTypeFilter = 'all';
  bool showFilters = false;
  DateTime? customStartDate;
  DateTime? customEndDate;
  int? selectedWeek;
  int? selectedMonth;
  int? selectedYear;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  late Box<Transaction> transactionBox;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<Transaction>('transactions');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _getFilterButtonText() {
    String typeText = selectedTypeFilter == 'all'
        ? 'Todos'
        : selectedTypeFilter == 'income'
            ? 'Ingresos'
            : 'Gastos';
    String periodText = getPeriodLabel();
    return '$typeText • $periodText';
  }

  List<Transaction> getFilteredTransactions() {
    final now = DateTime.now();
    var transactions = transactionBox.values.cast<Transaction>().toList();

    final periodFiltered = transactions.where((transaction) {
      if (customStartDate != null && customEndDate != null) {
        return transaction.date
                .isAfter(customStartDate!.subtract(const Duration(days: 1))) &&
            transaction.date
                .isBefore(customEndDate!.add(const Duration(days: 1)));
      }

      if (selectedWeek != null && selectedYear != null) {
        final weekStart = _getStartOfWeek(selectedYear!, selectedWeek!);
        final weekEnd = weekStart.add(const Duration(days: 6));
        return transaction.date
                .isAfter(weekStart.subtract(const Duration(days: 1))) &&
            transaction.date.isBefore(weekEnd.add(const Duration(days: 1)));
      }

      if (selectedMonth != null && selectedYear != null) {
        return transaction.date.year == selectedYear &&
            transaction.date.month == selectedMonth;
      }

      if (selectedYear != null && selectedMonth == null) {
        return transaction.date.year == selectedYear;
      }

      switch (selectedPeriodFilter) {
        case 'daily':
          return transaction.date.year == now.year &&
              transaction.date.month == now.month &&
              transaction.date.day == now.day;
              case 'yesterday':
  return TransactionHelpers.isYesterday(transaction.date);
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

    final typeFiltered = periodFiltered.where((transaction) {
      if (selectedTypeFilter == 'all') return true;
      return transaction.type == selectedTypeFilter;
    }).toList();

    final searchFiltered = typeFiltered.where((transaction) {
      if (searchQuery.isEmpty) return true;
      final keywords = searchQuery
          .toLowerCase()
          .split(',')
          .map((k) => k.trim())
          .where((k) => k.isNotEmpty)
          .toList();
      if (keywords.isEmpty) return true;
      return keywords.any(
          (keyword) => transaction.description.toLowerCase().contains(keyword));
    }).toList();

    searchFiltered.sort((a, b) => b.date.compareTo(a.date));
    return searchFiltered;
  }

  DateTime _getStartOfWeek(int year, int week) {
    final firstDayOfYear = DateTime(year, 1, 1);
    final daysToAdd = (week - 1) * 7;
    final weekStart = firstDayOfYear.add(Duration(days: daysToAdd));
    return weekStart.subtract(Duration(days: weekStart.weekday - 1));
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

  String getPeriodLabel() {
    if (customStartDate != null && customEndDate != null) {
      return '${customStartDate!.day}/${customStartDate!.month}/${customStartDate!.year} - ${customEndDate!.day}/${customEndDate!.month}/${customEndDate!.year}';
    }
    if (selectedWeek != null && selectedYear != null) {
      return 'Semana $selectedWeek de $selectedYear';
    }
    if (selectedMonth != null && selectedYear != null) {
      final monthNames = [
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic'
      ];
      return '${monthNames[selectedMonth! - 1]} $selectedYear';
    }
    if (selectedYear != null) {
      return 'Año $selectedYear';
    }
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

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: customStartDate != null && customEndDate != null
          ? DateTimeRange(start: customStartDate!, end: customEndDate!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        customStartDate = picked.start;
        customEndDate = picked.end;
        selectedPeriodFilter = 'custom';
        selectedWeek = null;
        selectedMonth = null;
        selectedYear = null;
      });
    }
  }

  void _showWeekPicker() async {
    final now = DateTime.now();
    final year = await showDialog<int>(
      context: context,
      builder: (context) =>
          YearPickerDialog(initialYear: selectedYear ?? now.year),
    );

    if (year != null) {
      final week = await showDialog<int>(
        context: context,
        builder: (context) => WeekPickerDialog(year: year),
      );

      if (week != null) {
        setState(() {
          selectedWeek = week;
          selectedYear = year;
          selectedPeriodFilter = 'custom';
          customStartDate = null;
          customEndDate = null;
          selectedMonth = null;
        });
      }
    }
  }

  void _showMonthPicker() async {
    final now = DateTime.now();
    final year = await showDialog<int>(
      context: context,
      builder: (context) =>
          YearPickerDialog(initialYear: selectedYear ?? now.year),
    );

    if (year != null) {
      final month = await showDialog<int>(
        context: context,
        builder: (context) => const MonthPickerDialog(),
      );

      if (month != null) {
        setState(() {
          selectedMonth = month;
          selectedYear = year;
          selectedPeriodFilter = 'custom';
          customStartDate = null;
          customEndDate = null;
          selectedWeek = null;
        });
      }
    }
  }

  void _showYearPicker() async {
    final year = await showDialog<int>(
      context: context,
      builder: (context) =>
          YearPickerDialog(initialYear: selectedYear ?? DateTime.now().year),
    );

    if (year != null) {
      setState(() {
        selectedYear = year;
        selectedMonth = null;
        selectedWeek = null;
        selectedPeriodFilter = 'custom';
        customStartDate = null;
        customEndDate = null;
      });
    }
  }

  void _clearCustomFilters() {
    setState(() {
      customStartDate = null;
      customEndDate = null;
      selectedWeek = null;
      selectedMonth = null;
      selectedYear = null;
      selectedPeriodFilter = 'daily';
      searchQuery = '';
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '📊 Historial',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => showFilters = !showFilters),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _getFilterButtonText(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                                showFilters
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 24),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: showFilters
                          ? FilterPanel(
                              selectedTypeFilter: selectedTypeFilter,
                              selectedPeriodFilter: selectedPeriodFilter,
                              onDateRangePressed: _showDateRangePicker,
                              onWeekPressed: _showWeekPicker,
                              onMonthPressed: _showMonthPicker,
                              onYearPressed: _showYearPicker,
                              onClearPressed: _clearCustomFilters,
                              hasActiveFilters: customStartDate != null ||
                                  selectedWeek != null ||
                                  selectedMonth != null ||
                                  selectedYear != null ||
                                  searchQuery.isNotEmpty,
                              onTypeChanged: (type) =>
                                  setState(() => selectedTypeFilter = type),
                              onPeriodChanged: (period) =>
                                  setState(() => selectedPeriodFilter = period),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 12),
                    CustomSearchBar(
                      controller: searchController,
                      query: searchQuery,
                      onClear: () => setState(() {
                        searchController.clear();
                        searchQuery = '';
                      }),
                      onSearchChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
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
                                AppColors.primary.withOpacity(0.1),
                                AppColors.primaryLight.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Text(getPeriodLabel(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                TransactionHelpers.formatCurrency(total),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: total >= 0
                                      ? AppColors.income
                                      : AppColors.expense,
                                ),
                              ),
                              Text(
                                '${filteredTransactions.length} transacción${filteredTransactions.length != 1 ? 'es' : ''}',
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: transactionBox.listenable(),
                      builder: (context, Box<Transaction> box, _) {
                        return TransactionList(
                          transactions: getFilteredTransactions(),
                          transactionBox: transactionBox,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
