import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) onDelete;
  final DateTime? selectedMonth;

  const TransactionList({
    required this.transactions,
    required this.onDelete,
    this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    List<Transaction> filteredTransactions = transactions;

    if (selectedMonth != null) {
      filteredTransactions = transactions
          .where((transaction) =>
              transaction.date.year == selectedMonth!.year &&
              transaction.date.month == selectedMonth!.month)
          .toList();
    }

    return ListView.builder(
      itemCount: filteredTransactions.length,
      itemBuilder: (ctx, index) {
        final transaction = filteredTransactions[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(transaction.category),
            subtitle: Text(
                '${transaction.amount.toStringAsFixed(2)} - ${transaction.date.toString()} - ${transaction.note}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onDelete(transaction.id),
            ),
          ),
        );
      },
    );
  }
}