import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';

class TransactionChart extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) onCategorySelected;

  const TransactionChart({
    required this.transactions,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categoryAmounts = _calculateCategoryAmounts();

    final bars = categoryAmounts.entries.map((entry) {
      int index = categoryAmounts.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            gradient: LinearGradient( // Gradien warna batang chart
              colors: [
                      Color(0xFFE8F9FF),
                      Color(0xFFC4D9FF),
                      Color(0xFFC5BAFF),
                    ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 22, // Lebar batang lebih besar agar lebih menarik
            borderRadius: BorderRadius.circular(12), // Membuat batang lebih smooth
          ),
        ],
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          backgroundColor: Colors.white, // Background putih agar lebih clean
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
              dashArray: [5, 5], // Garis putus-putus agar lebih rapi
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      categoryAmounts.keys.toList()[value.toInt()],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.shade300),
          ),
          barGroups: bars,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // tooltipBackgroundColor: Colors.black87,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final category = categoryAmounts.keys.toList()[group.x];
                return BarTooltipItem(
                  '$category\nRp ${categoryAmounts[category]?.toStringAsFixed(2)}',
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                return;
              }
              final touchedGroupIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              final category = categoryAmounts.keys.toList()[touchedGroupIndex];
              onCategorySelected(category);
            },
            handleBuiltInTouches: true, // Efek klik lebih halus
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
