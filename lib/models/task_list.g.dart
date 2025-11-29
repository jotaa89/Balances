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
