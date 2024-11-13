import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/homepage.dart';
import 'package:myapp/service/pemasukan_service.dart';
import 'package:myapp/service/pengeluaran_service.dart';
import 'model/pemasukan_model.dart';
import 'model/pengeluaran_model.dart';

class TambahCatatan extends StatefulWidget {
  const TambahCatatan({super.key});

  @override
  State<TambahCatatan> createState() => _TambahCatatanState();
}

class _TambahCatatanState extends State<TambahCatatan> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedText = 'Pemasukkan';
  String _selectedCategory = '';

  Future<List<String>> _fetchCategories() async {
    String collectionName =
        _selectedText == 'Pemasukkan' ? 'Pemasukan' : 'Pengeluaran';

    final snapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    return snapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _clearDate() {
    setState(() {
      _selectedDate = null;
    });
  }

  void _saveData() {
    if (_noteController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedCategory.isNotEmpty) {
      final double amount = double.parse(_amountController.text);

      if (_selectedText == 'Pemasukkan') {
        final Pemasukan data = Pemasukan(
          id: '',
          amount: amount,
          date: _selectedDate!,
          category: _selectedCategory,
          note: _noteController.text,
        );
        PemasukanService().addPemasukan(data);
      } else {
        final Pengeluaran data = Pengeluaran(
          id: '',
          amount: amount,
          date: _selectedDate!,
          category: _selectedCategory,
          note: _noteController.text,
        );
        PengeluaranService().addPengeluaran(data);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Data Tidak Lengkap"),
            content: const Text("Silakan isi semua kolom."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3ECF7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom AppBar
            Container(
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFF4CA0D1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      padding: const EdgeInsets.only(top: 5),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        child: DropdownButton<String>(
                          underline: Container(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          dropdownColor: const Color(0xFF4CA0D1),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          items: const [
                            DropdownMenuItem(
                              value: 'Pemasukkan',
                              child: Text('Pemasukkan'),
                            ),
                            DropdownMenuItem(
                              value: 'Pengeluaran',
                              child: Text('Pengeluaran'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedText = value!;
                              _selectedCategory = '';
                            });
                          },
                          value: _selectedText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Category Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: FutureBuilder<List<String>>(
                    future: _fetchCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("Error fetching categories");
                      } else {
                        final categories = snapshot.data ?? [];
                        return DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          value: _selectedCategory.isEmpty
                              ? null
                              : _selectedCategory,
                          hint: const Text(
                            'Pilih Kategori',
                            style: TextStyle(fontSize: 15),
                          ),
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Amount Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: '(Masukkan jumlah)',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Date Picker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Pilih Tanggal'
                            : '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, size: 25),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Note Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      labelText: 'Catatan',
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: '(Masukkan catatan)',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveData,
        icon: const Icon(Icons.save),
        label: const Text("Simpan"),
      ),
    );
  }
}
