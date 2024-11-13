import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/EditPemasukanScreen.dart';
import 'package:myapp/EditPengeluaranScreen.dart';
import 'package:myapp/model/pemasukan_model.dart';
import 'package:myapp/model/pengeluaran_model.dart';
import 'package:myapp/tambah_catatan.dart';
import 'package:myapp/kategori.dart';
import 'package:myapp/cari.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic>? newEntry;

  const HomePage({Key? key, this.newEntry}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Color appBarBackgroundColor = const Color(0xFF4CA0D1);
  bool isDarkMode = false;
  double totalPemasukkan = 0.0;
  double totalPengeluaran = 0.0;
  double totalKeuangan = 0.0;

  @override
  void initState() {
    super.initState();
    fetchTotalAmounts();
  }

  void fetchTotalAmounts() {
    FirebaseFirestore.instance
        .collection('pemasukan')
        .snapshots()
        .listen((snapshot) {
      double pemasukkan = snapshot.docs
          .fold(0.0, (sum, doc) => sum + (doc['amount'] as num).toDouble());
      setState(() {
        totalPemasukkan = pemasukkan;
        totalKeuangan = totalPemasukkan - totalPengeluaran;
      });
    });

    FirebaseFirestore.instance
        .collection('pengeluaran')
        .snapshots()
        .listen((snapshot) {
      double pengeluaran = snapshot.docs
          .fold(0.0, (sum, doc) => sum + (doc['amount'] as num).toDouble());
      setState(() {
        totalPengeluaran = pengeluaran;
        totalKeuangan = totalPemasukkan - totalPengeluaran;
      });
    });
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,##0", "id_ID");
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[850] : const Color(0xFFE3ECF7),
      body: Column(
        children: [
          // AppBar Kustom
          Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              color: appBarBackgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello',
                  style: GoogleFonts.lobster(
                    textStyle: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 48, 46, 65),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(
                children: [
                  // Bagian Total Keuangan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Keuangan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Rp${formatCurrency(totalKeuangan)}',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 20.0),
                        Text(
                          'Pemasukkan: Rp${formatCurrency(totalPemasukkan)}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                        Text(
                          'Pengeluaran: Rp${formatCurrency(totalPengeluaran)}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // List Pemasukkan
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('pemasukan')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');
                      List<Pemasukan> pemasukanList =
                          snapshot.data!.docs.map((doc) {
                        return Pemasukan(
                          id: doc.id,
                          amount: (doc['amount'] as num).toDouble(),
                          date: DateTime.parse(doc['date']),
                          category: doc['category'],
                          note: doc['note'],
                        );
                      }).toList();

                      return Column(
                        children: pemasukanList.map((pemasukan) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set a fixed color instead of conditional dark mode
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pemasukan.category,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black, // Fixed color
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        "Rp${formatCurrency(pemasukan.amount)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Colors.blue[900], // Fixed color
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        pemasukan.note,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Colors.grey[600], // Fixed color
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(pemasukan.date),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Colors.grey[600], // Fixed color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.green),
                                      onPressed: () {
                                        // Navigasi ke halaman edit, kirim data pemasukan untuk di-edit
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPemasukanScreen(
                                                    pemasukan: pemasukan),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        // Tampilkan dialog konfirmasi
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Konfirmasi"),
                                              content: const Text(
                                                  "Apakah Anda yakin ingin menghapus data ini?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Tutup dialog
                                                  },
                                                  child: const Text("Tidak"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Hapus data dari Firestore dan tutup dialog
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'pemasukan') // atau 'pengeluaran'
                                                        .doc(pemasukan
                                                            .id) // atau pengeluaran.id jika di bagian pengeluaran
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Ya"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 15),
                  // Untuk daftar Pengeluaran
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('pengeluaran')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');

                      List<Pengeluaran> pengeluaranList =
                          snapshot.data!.docs.map((doc) {
                        return Pengeluaran(
                          id: doc.id,
                          amount: (doc['amount'] as num).toDouble(),
                          date: DateTime.parse(doc['date']),
                          category: doc['category'],
                          note: doc['note'],
                        );
                      }).toList();

                      return Column(
                        children: pengeluaranList.map((pengeluaran) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set a fixed color instead of conditional dark mode
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pengeluaran.category,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors
                                              .black, // Set a fixed color instead of conditional dark mode
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        "Rp${formatCurrency(pengeluaran.amount)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red[
                                              900], // Set a fixed color instead of conditional dark mode
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        pengeluaran.note,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(pengeluaran.date),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[
                                              600], // Set a fixed color instead of conditional dark mode
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.green),
                                      onPressed: () {
                                        // Navigasi ke halaman edit, kirim data pengeluaran untuk di-edit
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPengeluaranScreen(
                                                    pengeluaran: pengeluaran),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        // Tampilkan dialog konfirmasi untuk penghapusan pengeluaran
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Konfirmasi"),
                                              content: const Text(
                                                  "Apakah Anda yakin ingin menghapus data pengeluaran ini?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Tutup dialog
                                                  },
                                                  child: const Text("Tidak"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Hapus data pengeluaran dari Firestore dan tutup dialog
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'pengeluaran')
                                                        .doc(pengeluaran.id)
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Ya"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 65.0,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: appBarBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 100.0),
                  child: Transform.translate(
                    offset: const Offset(0, -5),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Kategori(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.category_rounded,
                        color: Colors.white,
                        size: 35.0,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Cari(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: 35.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahCatatan(),
              ),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: const Color(0xFFFFFFFF),
          child: const Icon(Icons.add, color: Colors.black, size: 36.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
