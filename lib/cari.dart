import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cari extends StatefulWidget {
  const Cari({super.key});

  @override
  _CariState createState() => _CariState();
}

class _CariState extends State<Cari> {
  String searchQuery = ''; // Variabel untuk menyimpan kata kunci pencarian

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
                'Cari Catatan',
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
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Set kata kunci pencarian
                  print("Search Query: $searchQuery"); // Log pencarian
                });
              },
              decoration: const InputDecoration(
                labelText: 'Masukkan kata kunci pencarian',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchQuery.isEmpty
                  ? const Center(
                      child: Text('Masukkan kata kunci untuk mencari.'))
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('pemasukan')
                          .where('note', isGreaterThanOrEqualTo: searchQuery)
                          .where('note',
                              isLessThanOrEqualTo: searchQuery + '\uf8ff')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final results = snapshot.data!.docs;

                        if (results.isNotEmpty) {
                          return ListView(
                            children: results.map((doc) {
                              Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ListTile(
                                  title: Text(
                                      data['note'] ?? 'Catatan tidak tersedia'),
                                  subtitle: Text(
                                      'Rp${data['amount']} - ${data['category']}'),
                                ),
                              );
                            }).toList(),
                          );
                        }

                        // Jika tidak ada hasil untuk pemasukan, cek pengeluaran
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('pengeluaran')
                              .where('note',
                                  isGreaterThanOrEqualTo: searchQuery)
                              .where('note',
                                  isLessThanOrEqualTo: searchQuery + '\uf8ff')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final resultsPengeluaran = snapshot.data!.docs;

                            if (resultsPengeluaran.isNotEmpty) {
                              return ListView(
                                children: resultsPengeluaran.map((doc) {
                                  Map<String, dynamic> data =
                                      doc.data() as Map<String, dynamic>;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ListTile(
                                      title: Text(data['note'] ??
                                          'Catatan tidak tersedia'),
                                      subtitle: Text(
                                          'Rp${data['amount']} - ${data['category']}'),
                                    ),
                                  );
                                }).toList(),
                              );
                            }

                            return const Center(
                                child: Text('Tidak ada hasil ditemukan.'));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
