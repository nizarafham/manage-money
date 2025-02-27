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
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                      Color(0xFFE8F9FF),
                      Color(0xFFC4D9FF),
                      Color(0xFFC5BAFF),
                    ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tambah Transaksi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      labelStyle: TextStyle(color: Colors.grey[800]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Harga',
                      labelStyle: TextStyle(color: Colors.grey[800]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixText: 'Rp ',
                      prefixStyle: TextStyle(color: Colors.grey[800]),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Catatan (opsional)',
                      labelStyle: TextStyle(color: Colors.grey[800]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.note, color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
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
                          onTransactionsUpdated();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFBFBFB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.black, 
                              width: 1.0, 
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}