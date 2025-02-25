import 'package:flutter/material.dart';
import '../widgets/chart.dart';
import '../models/transaction.dart';

class ChartScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const ChartScreen({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final categoryAmounts = _calculateCategoryAmounts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Grafik Pengeluaran'),
      ),
      body: Column(
        children: [
          Expanded(
            child: TransactionChart(transactions: transactions),
          ),
          Expanded(
            child: ListView(
              children: categoryAmounts.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text(entry.value.toStringAsFixed(2)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _calculateCategoryAmounts() {
    final Map<String, double> categoryAmounts = {};
    for (var transaction in transactions) {
      categoryAmounts.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    return categoryAmounts;
  }
}