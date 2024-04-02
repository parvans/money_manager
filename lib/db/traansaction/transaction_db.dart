import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = "transaction-db";

abstract class TransactionDbFunctions {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel value);
  Future<void> deleteTransaction(String id);
  Future<void> deleteAllTransaction();
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }
  ValueNotifier<List<TransactionModel>> transactionListListener =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel value) async {
    final _TransDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _TransDB.put(value.id, value);
    refreashUia();
  }

  Future<void> refreashUia() async {
    final _list = await getTransactions();
    _list.sort((a, b) => a.date.compareTo(b.date));
    transactionListListener.value.clear();
    transactionListListener.value.addAll(_list.reversed);
    transactionListListener.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final transDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return transDB.values.toList();
  }

  @override
  Future<void> deleteAllTransaction() async {
    final transDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transDB.clear();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final transDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transDB.delete(id);
    refreashUia();
  }
}
