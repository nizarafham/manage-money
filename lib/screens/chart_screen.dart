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
      // appBar: AppBar(
      //   // title: Text('Grafik Pengeluaran'),
      // ),
      backgroundColor: Color(0xFFFBFBFB),
      body: Column(
        children: [
          Expanded(
            child: TransactionChart(
              transactions: transactions,
              onCategorySelected: (category) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryTransactionList(
                      transactions: transactions,
                      category: category,
                    ),
                  ),
                );
              },
            ),
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

class CategoryTransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final String category;

  const CategoryTransactionList({
    required this.transactions,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final filteredTransactions =
        transactions.where((t) => t.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi $category'),
      ),
      backgroundColor: Color(0xFFFBFBFB),
      body: ListView.builder(
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];
          return ListTile(
            title: Text(transaction.category),
            subtitle: Text(
                '${transaction.amount.toStringAsFixed(2)} - ${transaction.date.toString()} - ${transaction.note}'),
          );
        },
      ),
    );
  }
}