class Pengeluaran {
  final String id; // Tambahkan ID dokumen
  final double amount;
  final DateTime date;
  final String category;
  final String note;

  Pengeluaran({
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
    required this.note,
  });

  // Konversi Pengeluaran menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'note': note,
    };
  }

  // Membuat Pengeluaran dari Map
  factory Pengeluaran.fromMap(String id, Map<String, dynamic> map) {
    return Pengeluaran(
      id: id, // Ambil ID dari parameter
      amount: map['amount'] ?? 0,
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      category: map['category'] ?? '',
      note: map['note'] ?? '',
    );
  }
}
