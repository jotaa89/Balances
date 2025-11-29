import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MonthPickerDialog extends StatelessWidget {
  const MonthPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final months = [
      {'num': 1, 'name': 'Enero', 'emoji': '❄️'},
      {'num': 2, 'name': 'Febrero', 'emoji': '💕'},
      {'num': 3, 'name': 'Marzo', 'emoji': '🌸'},
      {'num': 4, 'name': 'Abril', 'emoji': '🌷'},
      {'num': 5, 'name': 'Mayo', 'emoji': '🌼'},
      {'num': 6, 'name': 'Junio', 'emoji': '☀️'},
      {'num': 7, 'name': 'Julio', 'emoji': '🏖️'},
      {'num': 8, 'name': 'Agosto', 'emoji': '🌻'},
      {'num': 9, 'name': 'Septiembre', 'emoji': '🍂'},
      {'num': 10, 'name': 'Octubre', 'emoji': '🎃'},
      {'num': 11, 'name': 'Noviembre', 'emoji': '🍁'},
      {'num': 12, 'name': 'Diciembre', 'emoji': '🎄'},
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '📆 Seleccionar Mes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              width: 250,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index];
                  return InkWell(
                    onTap: () => Navigator.pop(context, month['num']),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(month['emoji'] as String,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(
                            month['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
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
