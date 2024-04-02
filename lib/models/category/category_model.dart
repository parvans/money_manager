import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 2)
enum categoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense
}

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isDeleted;
  @HiveField(3)
  final categoryType type;

  CategoryModel({
    required this.name,
    required this.type,
    required this.id,
    this.isDeleted = false,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'CategoryModel{name: $name, type: $type, id: $id, isDeleted: $isDeleted}';
  }
}
