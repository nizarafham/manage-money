import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/transaction.dart';

class StorageService {
  static const _transactionsKey = 'transactions';

  Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    return transactionsJson
        .map((json) => Transaction.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<void> saveTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    transactions.add(transaction);
    final transactionsJson = transactions
        .map((t) => jsonEncode(t.toMap()))
        .toList();
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }

  Future<void> deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    transactions.removeWhere((t) => t.id == id);
    final transactionsJson = transactions
        .map((t) => jsonEncode(t.toMap()))
        .toList();
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }
}