import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class TipsDialog extends StatelessWidget {
  const TipsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      "Registra todos tus gastos diariamente para tener un control preciso",
      "Establece un presupuesto mensual y trata de no excederlo",
      "Ahorra al menos el 20% de tus ingresos cada mes",
      "Evita compras impulsivas, espera 24 horas antes de comprar algo costoso",
      "Revisa tus suscripciones y cancela las que no uses",
    ];

    return Dialog(
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
                color: AppColors.primary,
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
                          color: AppColors.primary,
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
                  backgroundColor: AppColors.primary,
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
    );
  }
}
