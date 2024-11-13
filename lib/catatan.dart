import 'package:flutter/material.dart';

class DetailCatatan extends StatefulWidget {
  const DetailCatatan({super.key});

  @override
  State<DetailCatatan> createState() => _DetailCatatanState();
}

class _DetailCatatanState extends State<DetailCatatan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title Section
            const Center(
              child: Column(
                children: [
                  Text(
                    'Detail Catatan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Divider(thickness: 2),
                ],
              ),
            ),

            // Kategori Field
            const SizedBox(height: 16),
            buildReceiptItem('Kategori:', 'Pemasukan'),
            const Divider(thickness: 1),

            // Tanggal Field
            const SizedBox(height: 8),
            buildReceiptItem('Tanggal:', '12.09.2024'),
            const Divider(thickness: 1),

            // Catatan Field
            const SizedBox(height: 8),
            buildReceiptItem('Catatan:', 'Monthly salary'),
            const Divider(thickness: 1),

            // Amount Section (like in a receipt for the total value)
            const SizedBox(height: 16),
            buildReceiptItem('Jumlah:', 'Rp. 20.000'),
            const Divider(thickness: 2),

            // Spacer for buttons to be at the bottom
            const Spacer(),

            // Buttons for Edit and Hapus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Action for Edit button
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action for Hapus button
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each line in the receipt
  Widget buildReceiptItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
