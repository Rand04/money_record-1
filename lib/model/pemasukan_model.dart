class Pemasukan {
  final String id; // Menyimpan ID dokumen
  final double amount;
  final DateTime date;
  final String category;
  final String note;

  Pemasukan({
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'note': note,
    };
  }

  factory Pemasukan.fromMap(Map<String, dynamic> map) {
    return Pemasukan(
      id: map['id'] ?? '',
      amount: map['amount'] ?? 0,
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      category: map['category'] ?? '',
      note: map['note'] ?? '',
    );
  }
}
