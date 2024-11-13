import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Menambah item pencatatan keuangan ke koleksi
  Future<void> tambahKeuangan({
    required String collectionPath,
    required String kategori,
    required String catatan,
    required DateTime tanggal,
  }) async {
    final item = {
      'kategori': kategori,
      'catatan': catatan,
      'tanggal': Timestamp.fromDate(tanggal),
    };
    await _firestore.collection(collectionPath).add(item);
  }

  /// Mengupdate item pencatatan keuangan di koleksi berdasarkan ID
  Future<void> updateKeuangan({
    required String collectionPath,
    required String id,
    required String kategori,
    required String catatan,
    required DateTime tanggal,
  }) async {
    final item = {
      'kategori': kategori,
      'catatan': catatan,
      'tanggal': Timestamp.fromDate(tanggal),
    };
    await _firestore.collection(collectionPath).doc(id).update(item);
  }

  /// Menghapus item pencatatan keuangan dari koleksi berdasarkan ID
  Future<void> hapusKeuangan({
    required String collectionPath,
    required String id,
  }) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  /// Mendapatkan stream list item pencatatan keuangan dari koleksi
  Stream<List<Map<String, dynamic>>> getListKeuangan({
    required String collectionPath,
  }) {
    return _firestore.collection(collectionPath).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'kategori': data['kategori'] ?? '',
              'catatan': data['catatan'] ?? '',
              'tanggal': (data['tanggal'] as Timestamp).toDate(),
            };
          }).toList(),
        );
  }

  /// Mendapatkan satu item pencatatan keuangan dari koleksi berdasarkan ID
  Future<Map<String, dynamic>> getKeuanganById({
    required String collectionPath,
    required String id,
  }) async {
    DocumentSnapshot doc = await _firestore.collection(collectionPath).doc(id).get();
    final data = doc.data() as Map<String, dynamic>;
    return {
      'kategori': data['kategori'] ?? '',
      'catatan': data['catatan'] ?? '',
      'tanggal': (data['tanggal'] as Timestamp).toDate(),
    };
  }
}
