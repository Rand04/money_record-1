import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model/pemasukan_model.dart';

class EditPemasukanScreen extends StatefulWidget {
  final Pemasukan pemasukan;

  const EditPemasukanScreen({Key? key, required this.pemasukan})
      : super(key: key);

  @override
  _EditPemasukanScreenState createState() => _EditPemasukanScreenState();
}

class _EditPemasukanScreenState extends State<EditPemasukanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.pemasukan.amount.toString();
    _noteController.text = widget.pemasukan.note;
    _selectedCategory = widget.pemasukan.category;
    _selectedDate = widget.pemasukan.date;
    _fetchCategories(); // Mengambil data kategori dari Firestore
  }

  Future<void> _fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Pemasukan').get();

    setState(() {
      _categories = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  Future<void> _updatePemasukan() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('pemasukan')
          .doc(widget.pemasukan.id)
          .update({
        'amount': double.parse(_amountController.text),
        'note': _noteController.text,
        'category': _selectedCategory,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      });
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            backgroundColor: const Color(0xFF4CA0D1),
            centerTitle: true, // Pastikan title berada di tengah
            titleSpacing: 0, // Atur jarak judul dengan leading
            leadingWidth: 70, // Lebarkan leading untuk mengatur posisi
            title: const Padding(
              padding: EdgeInsets.only(top: 28), // Geser judul ke bawah
              child: Text(
                'Edit Pemasukan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25, // Atur ukuran teks
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(top: 25.0), // Geser ikon ke bawah
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan jumlah';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory.isEmpty ? null : _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: InputBorder.none,
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    'Tanggal: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePemasukan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF4CA0D1), // Ganti dengan warna latar belakang yang diinginkan
                  foregroundColor:
                      Colors.white, // Ganti dengan warna teks yang diinginkan
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
