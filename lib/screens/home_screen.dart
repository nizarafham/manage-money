import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../widgets/transaction_list.dart';
import '../widgets/add_transaction_popup.dart';
import 'chart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<Transaction> _transactions = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await _storageService.getTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  Future<void> _addTransaction() async {
    await showAddTransactionDialog(context, _loadTransactions);
  }

  Future<void> _deleteTransaction(String id) async {
    await _storageService.deleteTransaction(id);
    _loadTransactions();
  }

  double _calculateTotal() {
    return _transactions.fold(0, (sum, transaction) => sum + transaction.amount);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    if (_selectedIndex == 0) {
      page = SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 150,
                width: double.infinity, // Lebar penuh layar
                decoration: BoxDecoration(
                  color: Colors.blue[100], // Warna latar belakang kotak
                  borderRadius: BorderRadius.circular(25), // Kelengkungan 25
                ),
                padding: const EdgeInsets.all(20), // Padding di dalam kotak
                child: Center(
                  child: Text(
                    'Total Transaksi: ${_calculateTotal().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TransactionList(
                transactions: _transactions,
                onDelete: _deleteTransaction,
              ),
            ),
          ],
        ),
      );
    } else {
      page = ChartScreen(transactions: _transactions);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Tracker'),
      ),
      body: page,
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _addTransaction,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: _selectedIndex == 0
          ? FloatingActionButtonLocation.centerDocked
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Chart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}