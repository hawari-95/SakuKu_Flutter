// Model untuk merepresentasikan sebuah data transaksi keuangan
enum TransactionType {
  income, // Pemasukan
  expense, // Pengeluaran
}

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? notes;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
  });

  // Getter pembantu untuk mengecek apakah transaksi ini merupakan pemasukan
  bool get isIncome => type == TransactionType.income;
}
