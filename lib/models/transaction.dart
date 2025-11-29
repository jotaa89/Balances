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
