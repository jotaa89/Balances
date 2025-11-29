import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF764ba2);
  static const Color primaryLight = Color(0xFFa78bfa);
  static const Color primaryGradient = Color(0xFF667eea);
  static const Color secondary = Color(0xFF8B5CF6);

  static const Color income = Color(0xFF10b981);
  static const Color incomeLight = Color(0xFF86efac);

  static const Color expense = Color(0xFFef4444);
  static const Color expenseLight = Color(0xFFfca5a5);

  static const Gradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF8B5CF6)],
  );
}
