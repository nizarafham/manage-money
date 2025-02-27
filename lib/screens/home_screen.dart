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
  DateTime? _selectedDate;

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
    if (_selectedDate == null) {
      return _transactions.fold(0, (sum, transaction) => sum + transaction.amount);
    } else {
      return _transactions
          .where((transaction) =>
              transaction.date.year == _selectedDate!.year &&
              transaction.date.month == _selectedDate!.month &&
              transaction.date.day == _selectedDate!.day)
          .fold(0, (sum, transaction) => sum + transaction.amount);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day, // Ubah ke DatePickerMode.day
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Simpan tanggal lengkap
      });
    }
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
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE8F9FF),
                      Color(0xFFC4D9FF),
                      Color(0xFFC5BAFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Transaksi: Rp ${_calculateTotal().toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFBFBFB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Pilih Tanggal'
                        : 'Tanggal: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                ),
                SizedBox(width: 10),
                if (_selectedDate != null)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFBFBFB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    child: Text('Lihat Semua'),
                  ),
              ],
            ),
            Expanded(
              child: TransactionList(
                transactions: _transactions,
                onDelete: _deleteTransaction,
                selectedDate: _selectedDate,
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
        title: const Text('Pocket Book!'),
        backgroundColor: Color(0xFFFBFBFB),
      ),
      body: page,
      backgroundColor: Color(0xFFFBFBFB),
      floatingActionButton: _selectedIndex == 0
          ? Container(
              width: 56.0, // Sesuaikan ukuran (sesuai FloatingActionButton)
              height: 56.0, // Sesuaikan ukuran (sesuai FloatingActionButton)
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Membuat bentuk lingkaran
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFC5BAFF),
                    Color(0xFFC4D9FF),
                    Color(0xFFE8F9FF),
                  ],
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.grey,), // sesuaikan warna icon
                onPressed: _addTransaction,
              ),
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
        backgroundColor: Color(0xFFFBFBFB),
        selectedItemColor: Color(0xFFC5BAFF),
        onTap: _onItemTapped,
      ),
    );
  }
}