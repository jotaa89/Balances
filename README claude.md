archivo pubspec.yaml

name: balances
description: A new Flutter project.
publish_to: 'none'
version: 0.1.0

environment:
  sdk: '>=3.1.5 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.0
  build_runner: ^2.4.6
  flutter_lints: ^2.0.0
  
 

flutter:
  uses-material-design: true

archivo: android/app/build.gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace "com.example.balances"
    compileSdk 34
    ndkVersion "25.1.8937393"  // ← Versión específica y estable
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    
    kotlinOptions {
        jvmTarget = '17'
    }
    
    defaultConfig {
        applicationId "com.example.balances"
        minSdk 21                 // ← Cambia de flutter.minSdkVersion a 21
        targetSdk 34              // ← Cambia de flutter.targetSdkVersion a 34
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true      // ← AÑADE ESTO
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.debug  // ← Temporal para debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'  // ← AÑADE ESTO
}

archivo android/build.gradle
buildscript {
    ext.kotlin_version = '1.9.22'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
         classpath 'com.android.tools.build:gradle:8.3.1'  // ← Compatible con Flutter 3.19+
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
     // AÑADE ESTO para evitar conflictos de plugins:
    configurations.all {
        resolutionStrategy {
            force 'com.google.guava:guava:28.1-android'
        }
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}


archivo android/settings.gradle
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.1.4" apply false
    id "org.jetbrains.kotlin.android" version "1.9.22" apply false
}

include ":app"

C:\Users\jemr1\Documents\balances\balances\lib\constants\app_colors.dart
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

C:\Users\jemr1\Documents\balances\balances\lib\models\task_list.dart
import 'package:hive/hive.dart';

part 'task_list.g.dart';

@HiveType(typeId: 1)
class TaskListModel extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late List<TaskItem> tasks;

  @HiveField(2)
  late DateTime createdAt;

  TaskListModel({
    required this.name,
    required this.tasks,
    required this.createdAt,
  });
}

@HiveType(typeId: 2)
class TaskItem {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late bool isCompleted;

  @HiveField(2)
  late DateTime createdAt;

  TaskItem({
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });
}

C:\Users\jemr1\Documents\balances\balances\lib\models\task_list.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskListModelAdapter extends TypeAdapter<TaskListModel> {
  @override
  final int typeId = 1;

  @override
  TaskListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskListModel(
      name: fields[0] as String,
      tasks: (fields[1] as List).cast<TaskItem>(),
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TaskListModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tasks)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskItemAdapter extends TypeAdapter<TaskItem> {
  @override
  final int typeId = 2;

  @override
  TaskItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskItem(
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TaskItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

C:\Users\jemr1\Documents\balances\balances\lib\models\transaction.dart
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late double amount;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String type; // 'income' o 'expense'

  @HiveField(3)
  late DateTime date;

  Transaction({
    required this.amount,
    required this.description,
    required this.type,
    required this.date,
  });
}

C:\Users\jemr1\Documents\balances\balances\lib\models\transaction.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      amount: fields[0] as double,
      description: fields[1] as String,
      type: fields[2] as String,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}


C:\Users\jemr1\Documents\balances\balances\lib\screens\home_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../widgets/home/balance_card.dart';
import '../widgets/home/action_buttons.dart';
import '../widgets/home/floating_nav.dart';
import '../widgets/dialogs/transaction_form.dart';
import '../widgets/dialogs/tips_dialog.dart';
import '../widgets/history/transaction_history_dialog.dart';
import '../utils/preferences.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Transaction> transactionBox;

  @override
  void initState() {
    super.initState();
    transactionBox = Hive.box<Transaction>('transactions');
    print('🔧 Box inicializado con ${transactionBox.length} transacciones');
  }

  void showTransactionDialog(String type,
    {Transaction? transactionToEdit, int? transactionKey, DateTime? initialDate}) {
  showDialog(
    context: context,
    builder: (context) => TransactionFormDialog(
      type: type,
      transactionToEdit: transactionToEdit,
      transactionKey: transactionKey,
      initialDate: initialDate,
    ),
  );
}

  void showTipsDialog() {
    showDialog(context: context, builder: (context) => const TipsDialog());
  }

  void showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => TransactionHistoryDialog(
        onAddTransaction: showTransactionDialog,
      ),
    );
  }

  void _toggleBalanceVisibility() {
    setState(() {
      final newValue = !AppPreferences.getShowBalance();
      AppPreferences.setShowBalance(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '💰 Control de Gastos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    BalanceCard(
                      transactionBox: transactionBox,
                      onToggleVisibility: _toggleBalanceVisibility,
                    ),
                    const SizedBox(height: 24),
                    ActionButtons(
                        onShowTransactionDialog: showTransactionDialog),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: showHistoryDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '📊 Ver Historial',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: const FloatingNavButton(),
    );
  }
}

C:\Users\jemr1\Documents\balances\balances\lib\screens\pending_tasks_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_list.dart';

class PendingTasksScreen extends StatefulWidget {
  const PendingTasksScreen({super.key});

  @override
  State<PendingTasksScreen> createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  late Box<TaskListModel> taskListBox;

  @override
  void initState() {
    super.initState();
    taskListBox = Hive.box<TaskListModel>('task_lists');
  }

  void _addNewList() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '📝 Nueva Lista',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF764ba2),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Nombre de la lista',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF764ba2), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          final newList = TaskListModel(
                            name: nameController.text,
                            tasks: [],
                            createdAt: DateTime.now(),
                          );
                          taskListBox.add(newList);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ Lista creada'),
                              backgroundColor: Color(0xFF764ba2),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF764ba2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Crear',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteList(int key) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            const Text('¿Estás seguro de que quieres eliminar esta lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      taskListBox.delete(key);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🗑️ Lista eliminada'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF8B5CF6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        '📋 Pendientes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: taskListBox.listenable(),
                    builder: (context, Box<TaskListModel> box, _) {
                      if (box.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.checklist_rounded,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay listas aún',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Presiona + para crear tu primera lista',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final key = box.keys.elementAt(index);
                          final taskList = box.get(key)!;
                          final completedTasks =
                              taskList.tasks.where((t) => t.isCompleted).length;

                          return Dismissible(
                            key: Key(key.toString()),
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(Icons.edit,
                                  color: Colors.white, size: 32),
                            ),
                            secondaryBackground: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete,
                                  color: Colors.white, size: 32),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                // Editar
                                final nameController =
                                    TextEditingController(text: taskList.name);

                                await showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '✏️ Editar Lista',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF764ba2),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              hintText: 'Nombre de la lista',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF764ba2),
                                                    width: 2),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    foregroundColor:
                                                        Colors.grey[700],
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: const Text('Cancelar',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (nameController
                                                        .text.isNotEmpty) {
                                                      taskList.name =
                                                          nameController.text;
                                                      taskList.save();
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              '✅ Lista actualizada'),
                                                          backgroundColor:
                                                              Color(0xFF764ba2),
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF764ba2),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                      'Actualizar',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                return false; // No eliminar
                              }
                              return await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar eliminación'),
                                  content: const Text(
                                      '¿Estás seguro de que quieres eliminar esta lista?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Eliminar',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              taskList.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🗑️ Lista eliminada'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF764ba2),
                                  child: Text(
                                    taskList.tasks.isEmpty
                                        ? '0'
                                        : '$completedTasks/${taskList.tasks.length}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  taskList.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  taskList.tasks.isEmpty
                                      ? 'Sin tareas'
                                      : '$completedTasks de ${taskList.tasks.length} completadas',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskListDetailScreen(
                                        taskListKey: key as int,
                                        taskList: taskList,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          onPressed: _addNewList,
          backgroundColor: const Color(0xFF764ba2),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// ============================================
// PANTALLA DE DETALLE DE LISTA
// ============================================
class TaskListDetailScreen extends StatefulWidget {
  final int taskListKey;
  final TaskListModel taskList;

  const TaskListDetailScreen({
    super.key,
    required this.taskListKey,
    required this.taskList,
  });

  @override
  State<TaskListDetailScreen> createState() => _TaskListDetailScreenState();
}

class _TaskListDetailScreenState extends State<TaskListDetailScreen> {
  late Box<TaskListModel> taskListBox;

  @override
  void initState() {
    super.initState();
    taskListBox = Hive.box<TaskListModel>('task_lists');
  }

  void _addTask() {
    final taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '✅ Nueva Tarea',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF764ba2),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: taskController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Descripción de la tarea',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF764ba2), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (taskController.text.isNotEmpty) {
                          final taskList = taskListBox.get(widget.taskListKey)!;
                          taskList.tasks.add(TaskItem(
                            title: taskController.text,
                            isCompleted: false,
                            createdAt: DateTime.now(),
                          ));
                          taskList.save();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ Tarea agregada'),
                              backgroundColor: Color(0xFF764ba2),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF764ba2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Agregar',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF8B5CF6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        widget.taskList.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: taskListBox.listenable(),
                    builder: (context, Box<TaskListModel> box, _) {
                      final taskList = box.get(widget.taskListKey);

                      if (taskList == null || taskList.tasks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.task_alt,
                                  size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No hay tareas aún',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Presiona + para agregar una tarea',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: taskList.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskList.tasks[index];

                          return Dismissible(
                            key: Key('${widget.taskListKey}_$index'),
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(Icons.edit,
                                  color: Colors.white, size: 28),
                            ),
                            secondaryBackground: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete,
                                  color: Colors.white, size: 28),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                // Editar tarea
                                final taskController =
                                    TextEditingController(text: task.title);

                                await showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '✏️ Editar Tarea',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF764ba2),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextField(
                                            controller: taskController,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Descripción de la tarea',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF764ba2),
                                                    width: 2),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    foregroundColor:
                                                        Colors.grey[700],
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: const Text('Cancelar',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (taskController
                                                        .text.isNotEmpty) {
                                                      task.title =
                                                          taskController.text;
                                                      taskList.save();
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              '✅ Tarea actualizada'),
                                                          backgroundColor:
                                                              Color(0xFF764ba2),
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF764ba2),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                      'Actualizar',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                return false;
                              }
                              return true; // Confirmar borrado
                            },
                            onDismissed: (direction) {
                              taskList.tasks.removeAt(index);
                              taskList.save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🗑️ Tarea eliminada'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: CheckboxListTile(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    task.isCompleted = value ?? false;
                                    taskList.save();
                                  });
                                },
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                                activeColor: const Color(0xFF764ba2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          onPressed: _addTask,
          backgroundColor: const Color(0xFF764ba2),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

C:\Users\jemr1\Documents\balances\balances\lib\utils\preferences.dart
import 'package:hive/hive.dart';

class AppPreferences {
  static const String _prefsBoxName = 'app_preferences';
  static const String _showBalanceKey = 'show_balance';

  static Box? _prefsBox;

  static Future<void> init() async {
    _prefsBox = await Hive.openBox(_prefsBoxName);
  }

  static bool getShowBalance() {
    return _prefsBox?.get(_showBalanceKey, defaultValue: true) ?? true;
  }

  static Future<void> setShowBalance(bool value) async {
    await _prefsBox?.put(_showBalanceKey, value);
  }
}

C:\Users\jemr1\Documents\balances\balances\lib\utils\transaction_helpers.dart
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

C:\Users\jemr1\Documents\balances\balances\lib\widgets\common\filter_option.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class FilterOption extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? emoji;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOption({
    super.key,
    required this.label,
    this.icon,
    this.emoji,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.black87,
              )
            else if (emoji != null)
              Text(
                emoji!,
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
C:\Users\jemr1\Documents\balances\balances\lib\widgets\dialogs\month_picker.dart
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
C:\Users\jemr1\Documents\balances\balances\lib\widgets\dialogs\tips_dialog.dart
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
C:\Users\jemr1\Documents\balances\balances\lib\widgets\dialogs\transaction_form.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction.dart';
import '../../utils/transaction_helpers.dart';
import '../../constants/app_colors.dart';

class TransactionFormDialog extends StatefulWidget {
  final String type;
  final Transaction? transactionToEdit;
  final int? transactionKey;
  final DateTime? initialDate;

  const TransactionFormDialog({
    super.key,
    required this.type,
    this.transactionToEdit,
    this.transactionKey,
    this.initialDate,
  });

  @override
  State<TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.transactionToEdit?.amount.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.transactionToEdit?.description ?? '',
    );
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transactionToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing
                  ? (widget.type == 'income'
                      ? '✏️ Editar Ingreso'
                      : '✏️ Editar Gasto')
                  : (widget.type == 'income'
                      ? '💵 Agregar Ingreso'
                      : '💸 Agregar Gasto'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.type == 'income'
                    ? AppColors.income
                    : AppColors.expense,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Fecha: ${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_today,
                      color: AppColors.primary),
                  tooltip: 'Cambiar fecha',
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '0.00',
                prefixText: '\$ ',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Descripción (opcional)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancelar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final box =
                          await Hive.openBox<Transaction>('transactions');
                      final amount = double.tryParse(amountController.text);
                      if (amount != null && amount > 0) {
                        if (isEditing && widget.transactionKey != null) {
                          final updatedTransaction = Transaction(
                            amount: amount,
                            description: descriptionController.text.isEmpty
                                ? 'Sin descripción'
                                : descriptionController.text,
                            type: widget.type,
                            date: selectedDate,
                          );
                          box.put(widget.transactionKey!, updatedTransaction);
                          Navigator.pop(context);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '✅ Transacción actualizada: ${TransactionHelpers.formatCurrency(amount)}'),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          final transaction = Transaction(
                            amount: amount,
                            description: descriptionController.text.isEmpty
                                ? 'Sin descripción'
                                : descriptionController.text,
                            type: widget.type,
                            date: selectedDate,
                          );
                          box.add(transaction);
                          Navigator.pop(context);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(widget.type == 'income'
                                    ? '✅ Ingreso agregado: ${TransactionHelpers.formatCurrency(amount)}'
                                    : '✅ Gasto agregado: ${TransactionHelpers.formatCurrency(amount)}'),
                                backgroundColor: widget.type == 'income'
                                    ? AppColors.income
                                    : AppColors.expense,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('⚠️ Por favor ingresa un monto válido'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEditing ? 'Actualizar' : 'Confirmar',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
C:\Users\jemr1\Documents\balances\balances\lib\widgets\dialogs\week_picker.dart
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
C:\Users\jemr1\Documents\balances\balances\lib\widgets\dialogs\year_picker.dart
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
C:\Users\jemr1\Documents\balances\balances\lib\widgets\history\custom_search_bar.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final VoidCallback onClear;
  final Function(String) onSearchChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.query,
    required this.onClear,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '🔍 Buscar (separa con comas)...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        suffixIcon: query.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
            : null,
      ),
      onChanged: onSearchChanged,
    );
  }
}
C:\Users\jemr1\Documents\balances\balances\lib\widgets\history\filter_panel.dart
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
C:\Users\jemr1\Documents\balances\balances\lib\widgets\history\transaction_history_dialog.dart
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
C:\Users\jemr1\Documents\balances\balances\lib\widgets\history\transaction_list.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction.dart';
import '../../utils/transaction_helpers.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dialogs/transaction_form.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Box<Transaction> transactionBox;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.transactionBox,
  });

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _editTransaction(
      BuildContext context, Transaction transaction, int key) {
    showDialog(
      context: context,
      builder: (context) => TransactionFormDialog(
        type: transaction.type,
        transactionToEdit: transaction,
        transactionKey: key,
        
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('No hay transacciones',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              const SizedBox(height: 8),
              Text('en este período',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final transactionKey = transactionBox.keys.firstWhere(
          (key) => transactionBox.get(key) == transaction,
        );
        final isIncome = transaction.type == 'income';

        return Dismissible(
          key: Key(transactionKey.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 32),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content: const Text(
                      '¿Estás seguro de que quieres eliminar esta transacción?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Eliminar',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            transaction.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '🗑️ Transacción eliminada: ${TransactionHelpers.formatCurrency(transaction.amount)}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: InkWell(
            onTap: () =>
                _editTransaction(context, transaction, transactionKey as int),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    isIncome
                        ? AppColors.income.withOpacity(0.05)
                        : AppColors.expense.withOpacity(0.05),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.15],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isIncome
                      ? AppColors.income.withOpacity(0.3)
                      : AppColors.expense.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'}${TransactionHelpers.formatCurrency(transaction.amount)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isIncome ? AppColors.income : AppColors.expense,
                        ),
                      ),
                      Text(
                        formatDate(transaction.date),
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transaction.description,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(isIncome ? '💵' : '🐜',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            isIncome ? 'Ingreso' : 'Gasto',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.edit, size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            'Tap para editar',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '← Desliza para borrar',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

C:\Users\jemr1\Documents\balances\balances\lib\widgets\history\type_filter_button.dart
import 'package:flutter/material.dart';
import '../common/filter_option.dart';

class TypeFilterButton extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  const TypeFilterButton({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilterOption(
            label: 'Todos',
            icon: Icons.list,
            value: 'all',
            isSelected: selectedType == 'all',
            onTap: () => onChanged('all'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilterOption(
            label: 'Ingresos',
            emoji: '💵',
            value: 'income',
            isSelected: selectedType == 'income',
            onTap: () => onChanged('income'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilterOption(
            label: 'Gastos',
            emoji: '🐜',
            value: 'expense',
            isSelected: selectedType == 'expense',
            onTap: () => onChanged('expense'),
          ),
        ),
      ],
    );
  }
}

C:\Users\jemr1\Documents\balances\balances\lib\widgets\home\action_buttons.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';



class ActionButtons extends StatelessWidget {
  final Function(String) onShowTransactionDialog;

  const ActionButtons({
    super.key,
    required this.onShowTransactionDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => onShowTransactionDialog('expense'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.expense, width: 3),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Column(
              children: [
                Text('🐜', style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(
                  'Gastos',
                  style: TextStyle(
                    color: AppColors.expense,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () => onShowTransactionDialog('income'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.income, width: 3),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Column(
              children: [
                Text('💵', style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(
                  'Ingresos',
                  style: TextStyle(
                    color: AppColors.income,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
C:\Users\jemr1\Documents\balances\balances\lib\widgets\home\balance_card.dart
import 'package:balances/utils/transaction_helpers.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'dart:ui';
import '../../constants/app_colors.dart';
import '../../models/transaction.dart';
import '../../utils/preferences.dart';


class BalanceCard extends StatelessWidget {
  final Box<Transaction> transactionBox;
  final VoidCallback onToggleVisibility;

  const BalanceCard({
    super.key,
    required this.transactionBox,
    required this.onToggleVisibility,
  });

  double calculateBalance() {
    double balance = 0;
    for (var transaction in transactionBox.values) {
      if (transaction.type == 'income') {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  Color getBalanceColor(double balance) {
    if (balance > 0) return AppColors.incomeLight;
    if (balance < 0) return AppColors.expenseLight;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),
      builder: (context, Box<Transaction> box, _) {
        final balance = calculateBalance();
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFa78bfa), Color(0xFF7c3aed)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Balance Total',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      AppPreferences.getShowBalance()
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: AppPreferences.getShowBalance()
                    ? Text(
                        TransactionHelpers.formatCurrency(balance),
                        key: const ValueKey('visible'),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: getBalanceColor(balance),
                        ),
                      )
                    : ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Text(
                          TransactionHelpers.formatCurrency(balance),
                          key: const ValueKey('hidden'),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: getBalanceColor(balance),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
C:\Users\jemr1\Documents\balances\balances\lib\widgets\home\floating_nav.dart
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
C:\Users\jemr1\Documents\balances\balances\lib\widgets\transaction_buttons.dart
import 'package:flutter/material.dart';

class TransactionButtons extends StatelessWidget {
  final VoidCallback onExpenseTap;
  final VoidCallback onIncomeTap;

  const TransactionButtons({
    super.key,
    required this.onExpenseTap,
    required this.onIncomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onExpenseTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFFef4444),
                width: 3,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Column(
              children: [
                Text('🐜', style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(
                  'Gastos',
                  style: TextStyle(
                    color: Color(0xFFef4444),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: onIncomeTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFF10b981),
                width: 3,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Column(
              children: [
                Text('💵', style: TextStyle(fontSize: 32)),
                SizedBox(height: 8),
                Text(
                  'Ingresos',
                  style: TextStyle(
                    color: Color(0xFF10b981),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
C:\Users\jemr1\Documents\balances\balances\lib\main.dart
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
C:\Users\jemr1\Documents\balances\balances\codemagic.yaml
# codemagic.yaml (VERSIÓN GRATUITA - DEBUG)
workflows:
  android-debug:
    name: Android Debug APK
    max_build_duration: 30
    # ELIMINA la línea instance_type o usa "linux"
    environment:
      flutter: 3.22.2          # O tu versión exacta: flutter: 3.22.2
    scripts:
      - name: Limpiar todo
        script: |
          flutter clean
          rm -rf android/.gradle
          rm -rf ~/.pub-cache
      - name: Instalar dependencias
        script: flutter pub get
      - name: Compilar APK debug
        script: flutter build apk --debug --target-platform android-arm64
    artifacts:
      - build/app/outputs/flutter-apk/app-debug.apk

este es el resultado de flutter --version
$ flutter --version 
Flutter 3.38.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 19074d12f7 (9 days ago) • 2025-11-20 17:53:13 -0500
Engine • hash 8bf2090718fea3655f466049a757f823898f0ad1 (revision 13e658725d) (8 days ago) • 2025-11-20 20:19:23.000Z
Tools • Dart 3.10.1 • DevTools 2.51.1

la siguiente ficha esta desactualizada y me gustaria que me devolviras actualizada
1. 
One-liner + stack
Proyecto: «Control-Gastos-Flutter».
Objetivo: «Tracker personal de ingresos/gastos 100 % local».
Stack: Flutter 3.19 | Dart 3.3 | Hive | Material 3 | Gradle 8.4.
2. 
Árbol de carpetas (solo archivos relevantes)
.
├── lib/
│ ├── models/transaction.dart # Hive TypeAdapter
│ ├── screens/home_screen.dart # Entry point UI
│ ├── widgets/home/ # Re-usables del Home
│ ├── widgets/history/ # Re-usables del Histórico
│ ├── widgets/dialogs/ # Dialogos transaccionales
│ ├── utils/transaction_helpers.dart # Formato de moneda
│ └── constants/app_colors.dart # Paleta única
├── android/app/build.gradle
├── pubspec.yaml
└── README.md
3. 
Instalación rápida
flutter pub get
flutter run --debug # ← comprueba que arranque sin rojo
4. 
Flujo de request crítico (el 80 % de los cambios)
Tap «+ Ingreso» → home_screen.dart::showTransactionDialog() →
transaction_form.dart → Hive.box.add() →
ValueListenableBuilder refresca BalanceCard
5. 
Notas de refactor / deuda técnica
 
Migrar Hive a Isar para consultas complejas y multi-thread.
 
Unificar todos los «formatCurrency» en un solo extension method.
 
Crear un TransactionBloc antes de añadir sincronización cloud.
6. 
Última modificación
2025-06-25  transaction_history_dialog.dart – renombrado para evitar conflicto con widget de Material.