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
