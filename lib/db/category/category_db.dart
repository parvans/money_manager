import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category/category_model.dart';

const CATEGORY_DB_NAME = "category-db";

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getcategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String id);
}

class CategoryDB implements CategoryDbFunctions {
  // singleton

  CategoryDB._internal();

  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener =
      ValueNotifier([]);
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreashUi();
  }

  @override
  Future<List<CategoryModel>> getcategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreashUi() async {
    final _allCategories = await getcategories();
    incomeCategoryListListener.value.clear();
    expenseCategoryListListener.value.clear();
    // splitting the categories into income and expense

    await Future.forEach(_allCategories, (CategoryModel category) {
      if (category.type == categoryType.income) {
        incomeCategoryListListener.value.add(category);
      } else {
        expenseCategoryListListener.value.add(category);
      }
    });

    incomeCategoryListListener.notifyListeners();
    expenseCategoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String id) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(id);
    refreashUi();
  }
}
