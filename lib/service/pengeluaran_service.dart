import 'package:myapp/model/pengeluaran_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PengeluaranService {
  final CollectionReference _pengeluaranCollection =
      FirebaseFirestore.instance.collection('pengeluaran');
  final CollectionReference _kategoriCollection =
      FirebaseFirestore.instance.collection('kategori');

  // Menambahkan data pengeluaran ke Firebase
  Future<void> addPengeluaran(Pengeluaran pengeluaran) async {
    await _pengeluaranCollection.add(pengeluaran.toMap());
  }

  // Mendapatkan semua data pengeluaran dari Firebase
  Future<List<Pengeluaran>> getPengeluaran() async {
    final querySnapshot = await _pengeluaranCollection.get();
    return querySnapshot.docs
        .map((doc) =>
            Pengeluaran.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Mendapatkan semua kategori dari Firebase
  Future<List<String>> getCategories() async {
    List<String> categories = [];
    try {
      final querySnapshot = await _kategoriCollection.get();
      for (var doc in querySnapshot.docs) {
        categories
            .add(doc['nama_kategori']); // Sesuaikan dengan field di Firestore
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return categories;
  }
}
