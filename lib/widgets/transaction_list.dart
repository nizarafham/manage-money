import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final Function(String) onDelete;
  final DateTime? selectedDate; // Filter berdasarkan tanggal (hari/bulan)

  const TransactionList({
    required this.transactions,
    required this.onDelete,
    this.selectedDate,
  });

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1; // Halaman saat ini
  final int _itemsPerPage = 10; // Jumlah item per halaman
  bool _isLoading = false; // Untuk menandai apakah sedang memuat data

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore); // Tambahkan listener untuk scroll
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Bersihkan controller
    super.dispose();
  }

  // Fungsi untuk memuat lebih banyak data saat pengguna menggulir ke bawah
  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading) {
        setState(() {
          _isLoading = true;
        });

        // Simulasi delay untuk memuat data (bisa diganti dengan pemanggilan API)
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _currentPage++; // Tambahkan halaman
            _isLoading = false;
          });
        });
      }
    }
  }

  // Fungsi untuk mendapatkan daftar transaksi yang sudah difilter dan dipaginasi
  List<Transaction> _getPaginatedTransactions() {
    List<Transaction> filteredTransactions = widget.transactions;

    // Filter berdasarkan tanggal jika dipilih
    if (widget.selectedDate != null) {
      filteredTransactions = widget.transactions
          .where((transaction) =>
              transaction.date.year == widget.selectedDate!.year &&
              transaction.date.month == widget.selectedDate!.month &&
              transaction.date.day == widget.selectedDate!.day) // Filter berdasarkan hari
          .toList();
    }

    // Paginasi data
    int startIndex = 0;
    int endIndex = _currentPage * _itemsPerPage;

    if (endIndex > filteredTransactions.length) {
      endIndex = filteredTransactions.length;
    }

    return filteredTransactions.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final paginatedTransactions = _getPaginatedTransactions();

    return Column(
      children: [
        // Tampilkan daftar transaksi
        Expanded(
          child: ListView.builder(
            controller: _scrollController, // Tambahkan ScrollController
            itemCount: paginatedTransactions.length + (_isLoading ? 1 : 0), // Tambahkan 1 untuk indikator loading
            itemBuilder: (ctx, index) {
              if (index == paginatedTransactions.length) {
                // Tampilkan indikator loading di bagian bawah
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final transaction = paginatedTransactions[index];
              return Card(
                color: Color(0xFFE8F9FF),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(transaction.category),
                  subtitle: Text(
                      '${transaction.amount.toStringAsFixed(2)} - ${transaction.date.toString()} - ${transaction.note}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => widget.onDelete(transaction.id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}