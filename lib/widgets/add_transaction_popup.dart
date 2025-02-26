import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

Future<void> showAddTransactionDialog(BuildContext context, Function() onTransactionsUpdated) async {
  final StorageService _storageService = StorageService();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Tambah Transaksi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent, // Warna judul yang cerah
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[50]!, Colors.purple[50]!], // Gradien warna pastel
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: TextStyle(color: Colors.purple[800]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.category, color: Colors.purple[800]),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  labelStyle: TextStyle(color: Colors.purple[800]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.purple[800]),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Catatan (opsional)',
                  labelStyle: TextStyle(color: Colors.purple[800]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.note, color: Colors.purple[800]),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Batal',
              style: TextStyle(
                color: Colors.purple[800],
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final newTransaction = Transaction(
                id: DateTime.now().toString(),
                category: categoryController.text,
                amount: double.parse(amountController.text),
                date: DateTime.now(),
                note: noteController.text.isNotEmpty ? noteController.text : null,
              );
              await _storageService.saveTransaction(newTransaction);
              onTransactionsUpdated(); // Panggil fungsi callback
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent, // Warna tombol yang cerah
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Simpan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white, // Warna latar belakang popup
      );
    },
  );
}