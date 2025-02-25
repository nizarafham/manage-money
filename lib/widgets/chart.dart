import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // New import
import '../models/transaction.dart';

class TransactionChart extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionChart({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final categoryAmounts = _calculateCategoryAmounts();

    final bars = categoryAmounts.entries.map((entry) {
      return BarChartGroupData(
        x: categoryAmounts.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.amber,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: bars,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(categoryAmounts.keys.toList()[value.toInt()]);
              },
            ),
          ),
        ),
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