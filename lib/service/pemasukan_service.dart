import 'package:myapp/model/pemasukan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PemasukanService {
  final CollectionReference _pemasukanCollection =
      FirebaseFirestore.instance.collection('pemasukan');
  final CollectionReference _kategoriCollection =
      FirebaseFirestore.instance.collection('kategori'); // Tambahkan koleksi kategori

  // Menambahkan data pemasukan ke Firebase
  Future<void> addPemasukan(Pemasukan pemasukan) async {
    await _pemasukanCollection.add(pemasukan.toMap());
  }

  // Mendapatkan semua data pemasukan dari Firebase
  Future<List<Pemasukan>> getPemasukan() async {
    final querySnapshot = await _pemasukanCollection.get();
    return querySnapshot.docs
        .map((doc) => Pemasukan.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Mendapatkan semua kategori dari Firebase
  Future<List<String>> getCategories() async {
    List<String> categories = [];
    try {
      final querySnapshot = await _kategoriCollection.get();
      for (var doc in querySnapshot.docs) {
        categories.add(doc['nama_kategori']); // Sesuaikan dengan field di Firestore
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return categories;
  }
}
