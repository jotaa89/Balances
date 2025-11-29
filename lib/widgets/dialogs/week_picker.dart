import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class WeekPickerDialog extends StatelessWidget {
  final int year;

  const WeekPickerDialog({super.key, required this.year});

  int _getWeeksInYear(int year) {
    final lastDayOfYear = DateTime(year, 12, 31);
    final firstDayOfYear = DateTime(year, 1, 1);
    final difference = lastDayOfYear.difference(firstDayOfYear).inDays;
    return (difference / 7).ceil() + 1;
  }

  DateTime _getStartOfWeek(int year, int week) {
    final firstDayOfYear = DateTime(year, 1, 1);
    final daysToAdd = (week - 1) * 7;
    final weekStart = firstDayOfYear.add(Duration(days: daysToAdd));
    return weekStart.subtract(Duration(days: weekStart.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final weeksInYear = _getWeeksInYear(year);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '📅 Seleccionar Semana de $year',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              width: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: weeksInYear,
                itemBuilder: (context, index) {
                  final weekNumber = index + 1;
                  final weekStart = _getStartOfWeek(year, weekNumber);
                  return InkWell(
                    onTap: () => Navigator.pop(context, weekNumber),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'S$weekNumber',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${weekStart.day}/${weekStart.month}',
                            style:
                                TextStyle(fontSize: 9, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar')),
          ],
        ),
      ),
    );
  }
}
