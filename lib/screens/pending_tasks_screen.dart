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
