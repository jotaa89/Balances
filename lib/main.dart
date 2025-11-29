import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart';
import 'models/task_list.dart';
import 'screens/home_screen.dart';
import 'utils/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive
  await Hive.initFlutter();

  // Registrar adaptadores
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TaskListModelAdapter());
  Hive.registerAdapter(TaskItemAdapter());

// Abrir boxes
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<TaskListModel>('task_lists');

  // Inicializar preferencias (para persistencia blur)
  await AppPreferences.init();

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
