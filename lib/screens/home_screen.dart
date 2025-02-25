import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../widgets/transaction_list.dart';
import 'chart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<Transaction> _transactions = [];
  int _selectedIndex = 0; // Tambahkan indeks untuk navbar

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
    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Transaksi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: 'Catatan (opsional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final newTransaction = Transaction(
                  id: DateTime.now().toString(),
                  category: categoryController.text,
                  amount: double.parse(amountController.text),
                  date: DateTime.now(),
                  note: noteController.text.isNotEmpty ? noteController.text : null,
                );
                await _storageService.saveTransaction(newTransaction);
                _loadTransactions();
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
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
      page = Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Total Transaksi: ${_calculateTotal().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TransactionList(
              transactions: _transactions,
              onDelete: _deleteTransaction,
            ),
          ),
        ],
      );
    } else {
      page = ChartScreen(transactions: _transactions);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Tracker'),
      ),
      body: page, // Gunakan widget 'page' yang ditentukan oleh indeks
      floatingActionButton: _selectedIndex == 0 //Tampilkan Fab hanya di home
          ? FloatingActionButton(
              onPressed: _addTransaction,
              child: Icon(Icons.add),
            )
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