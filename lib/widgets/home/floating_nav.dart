import 'package:balances/screens/pending_tasks_screen.dart';
import 'package:flutter/material.dart';


class FloatingNavButton extends StatelessWidget {
  const FloatingNavButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PendingTasksScreen()),
              );
            },
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                'Pendientes →',
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