import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) onDelete;

  const TransactionList({
    required this.transactions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, index) {
        final transaction = transactions[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(transaction.category),
            subtitle: Text('${transaction.amount.toStringAsFixed(2)} - ${transaction.date.toString()}'),
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