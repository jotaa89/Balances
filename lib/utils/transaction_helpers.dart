import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionHelpers {
  // Formatear moneda con separador de miles
  static String formatCurrency(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Agregar puntos cada 3 dígitos
    String formattedInteger = '';
    int count = 0;

    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (count == 3) {
        formattedInteger = '.$formattedInteger';
        count = 0;
      }
      formattedInteger = integerPart[i] + formattedInteger;
      count++;
    }

    // Si los decimales son .00, no mostrarlos
    if (decimalPart == '00') {
      return '\$' + formattedInteger;
    }

    return '\$' + formattedInteger + ',' + decimalPart;
  }

  // Formatear fecha
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Calcular balance
  static double calculateBalance(Box<Transaction> box) {
    double balance = 0;
    for (var transaction in box.values) {
      if (transaction.type == 'income') {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  // Calcular total de lista filtrada
  static double calculateTotal(List<Transaction> transactions) {
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

  // Obtener color del balance
  static Color getBalanceColor(double balance) {
    if (balance > 0) return const Color(0xFF86efac);
    if (balance < 0) return const Color(0xFFfca5a5);
    return Colors.white;
  }

  // Obtener inicio de semana
  static DateTime getStartOfWeek(int year, int week) {
    final firstDayOfYear = DateTime(year, 1, 1);
    final daysToAdd = (week - 1) * 7;
    final weekStart = firstDayOfYear.add(Duration(days: daysToAdd));
    return weekStart.subtract(Duration(days: weekStart.weekday - 1));
  }

  // Nombres de meses
  static const List<String> monthNames = [
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

  // Consejos financieros
  static const List<String> financialTips = [
    "Registra todos tus gastos diariamente para tener un control preciso",
    "Establece un presupuesto mensual y trata de no excederlo",
    "Ahorra al menos el 20% de tus ingresos cada mes",
    "Evita compras impulsivas, espera 24 horas antes de comprar algo costoso",
    "Revisa tus suscripciones y cancela las que no uses",
  ];
   /// Verifica si una fecha corresponde a ayer
  static bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    return normalizedDate == yesterday;
  }
}

