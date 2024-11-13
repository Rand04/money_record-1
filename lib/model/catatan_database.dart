import 'package:cloud_firestore/cloud_firestore.dart';

class Catatan {
  String id;           // Tambahan properti id
  String kategori;
  String catatan;
  DateTime tanggal;

  Catatan({
    required this.id,
    required this.kategori,
    required this.catatan,
    required this.tanggal,
  });

  factory Catatan.fromDocument(DocumentSnapshot doc) {
    return Catatan(
      id: doc.id,  // Mengambil id dari dokumen
      kategori: doc['kategori'] ?? '',
      catatan: doc['catatan'] ?? '',
      tanggal: (doc['tanggal'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kategori': kategori,
      'catatan': catatan,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}
