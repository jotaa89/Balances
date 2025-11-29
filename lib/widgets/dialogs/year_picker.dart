import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class YearPickerDialog extends StatelessWidget {
  final int initialYear;

  const YearPickerDialog({super.key, required this.initialYear});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (index) => currentYear - index);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '📅 Seleccionar Año',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              width: 200,
              child: ListView.builder(
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  return ListTile(
                    title: Text(
                      year.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: year == initialYear ? FontWeight.bold : FontWeight.normal,
                        color: year == initialYear ? AppColors.primary : Colors.black87,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, year),
                    tileColor: year == initialYear
                        ? AppColors.primary.withOpacity(0.1)
                        : null,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ],
        ),
      ),
    );
  }
}