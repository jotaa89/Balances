import 'package:flutter/material.dart';
import 'type_filter_button.dart';
import '../../constants/app_colors.dart';

class FilterPanel extends StatelessWidget {
  final String selectedTypeFilter;
  final String selectedPeriodFilter;
  final VoidCallback onDateRangePressed;
  final VoidCallback onWeekPressed;
  final VoidCallback onMonthPressed;
  final VoidCallback onYearPressed;
  final VoidCallback onClearPressed;
  final bool hasActiveFilters;
  final Function(String) onTypeChanged;
  final Function(String) onPeriodChanged;

  const FilterPanel({
    super.key,
    required this.selectedTypeFilter,
    required this.selectedPeriodFilter,
    required this.onDateRangePressed,
    required this.onWeekPressed,
    required this.onMonthPressed,
    required this.onYearPressed,
    required this.onClearPressed,
    required this.hasActiveFilters,
    required this.onTypeChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tipo de transacción',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TypeFilterButton(
                  selectedType: selectedTypeFilter,
                  onChanged: onTypeChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Período de tiempo',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
  label: const Text('Ayer'),
  selected: selectedPeriodFilter == 'yesterday',
  onSelected: (selected) => onPeriodChanged('yesterday'),
  selectedColor: AppColors.primary,
  checkmarkColor: Colors.white,
  labelStyle: TextStyle(
    color: selectedPeriodFilter == 'yesterday' ? Colors.white : Colors.black87,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  ),
),
              FilterChip(
                label: const Text('Hoy'),
                selected: selectedPeriodFilter == 'daily',
                onSelected: (selected) => onPeriodChanged('daily'),
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: selectedPeriodFilter == 'daily'
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              FilterChip(
                label: const Text('Esta Semana'),
                selected: selectedPeriodFilter == 'weekly',
                onSelected: (selected) => onPeriodChanged('weekly'),
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: selectedPeriodFilter == 'weekly'
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              FilterChip(
                label: const Text('Este Mes'),
                selected: selectedPeriodFilter == 'monthly',
                onSelected: (selected) => onPeriodChanged('monthly'),
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: selectedPeriodFilter == 'monthly'
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              FilterChip(
                label: const Text('Este Año'),
                selected: selectedPeriodFilter == 'yearly',
                onSelected: (selected) => onPeriodChanged('yearly'),
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: selectedPeriodFilter == 'yearly'
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Filtros personalizados',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: onDateRangePressed,
                icon: const Icon(Icons.date_range, size: 16),
                label: const Text('Rango', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onWeekPressed,
                icon: const Icon(Icons.view_week, size: 16),
                label: const Text('Semana', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onMonthPressed,
                icon: const Icon(Icons.calendar_month, size: 16),
                label: const Text('Mes', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onYearPressed,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('Año', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              if (hasActiveFilters)
                ElevatedButton.icon(
                  onPressed: onClearPressed,
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Limpiar', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
