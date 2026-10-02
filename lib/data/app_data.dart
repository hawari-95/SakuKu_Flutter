import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

/// Class AppData bertindak sebagai State Management lokal (Singleton & ChangeNotifier)
/// untuk menyimpan data aplikasi di memori selama sesi berjalan.
class AppData extends ChangeNotifier {
  // Singleton pattern agar instance selalu konsisten di semua halaman
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal();

  // Informasi pengguna & target tabungan
  String userName = 'Budi Santoso';
  double dailySavingsTarget = 30000.0;

  // Daftar transaksi awal (Dummy Data) agar saat aplikasi pertama kali dijalankan sudah ada data
  final List<TransactionModel> _transactions = [
    TransactionModel(
      id: 'tx_1',
      title: 'Uang Saku Bulanan',
      amount: 1500000,
      type: TransactionType.income,
      category: 'Gaji/Pemasukan',
      date: DateTime.now().subtract(const Duration(days: 2)),
      notes: 'Transfer dari orang tua',
    ),
    TransactionModel(
      id: 'tx_2',
      title: 'Makan Siang Nasi Padang',
      amount: 25000,
      type: TransactionType.expense,
      category: 'Makanan',
      date: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Lauk ayam bakar + es teh',
    ),
    TransactionModel(
      id: 'tx_3',
      title: 'Isi Bensin Motor',
      amount: 35000,
      type: TransactionType.expense,
      category: 'Transportasi',
      date: DateTime.now().subtract(const Duration(hours: 6)),
      notes: 'Pertalite full tank',
    ),
    TransactionModel(
      id: 'tx_4',
      title: 'Tiket Bioskop',
      amount: 50000,
      type: TransactionType.expense,
      category: 'Hiburan',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      notes: 'Nonton bareng teman',
    ),
  ];

  // Getter daftar transaksi (read-only)
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  // Menambahkan transaksi baru ke daftar paling atas
  void addTransaction(TransactionModel item) {
    _transactions.insert(0, item);
    notifyListeners();
  }

  // Menghapus transaksi berdasarkan ID
  void deleteTransaction(String id) {
    _transactions.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Menghitung total pemasukan
  double get totalIncome {
    return _transactions
        .where((item) => item.type == TransactionType.income)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Menghitung total pengeluaran
  double get totalExpense {
    return _transactions
        .where((item) => item.type == TransactionType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Menghitung sisa saldo total (Pemasukan - Pengeluaran)
  double get totalBalance => totalIncome - totalExpense;

    // Tabungan hari ini = pemasukan hari ini - pengeluaran hari ini (minimal 0)
  double get todaySavings {
    final DateTime now = DateTime.now();
    double total = 0;
    for (final item in _transactions) {
      final bool hariIni = item.date.year == now.year &&
          item.date.month == now.month &&
          item.date.day == now.day;
      if (hariIni) {
        total += item.isIncome ? item.amount : -item.amount;
      }
    }
    return total < 0 ? 0 : total;
  }

  // Progress 0.0 sampai 1.0 terhadap target harian
  double get savingsProgress {
    if (dailySavingsTarget <= 0) return 0;
    return (todaySavings / dailySavingsTarget).clamp(0.0, 1.0).toDouble();
  }

  // Mengubah nama pengguna saat login
  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  // Mengubah target tabungan harian
  void setDailySavingsTarget(double target) {
    dailySavingsTarget = target;
    notifyListeners();
  }

  // =========================================================================
  // HELPER FUNCTIONS (Formatting & UI Support tanpa dependensi eksternal)
  // =========================================================================

  /// Format angka ke bentuk mata uang Rupiah standar (Contoh: Rp 1.500.000)
  static String formatRupiah(num amount) {
    final bool isNegative = amount < 0;
    final int absAmount = amount.abs().round();
    final String digits = absAmount.toString();
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }

    final String result = buffer.toString();
    return isNegative ? '-Rp $result' : 'Rp $result';
  }

  /// Format objek DateTime ke string tanggal Indonesia (Contoh: 02 Okt 2026)
  static String formatTanggal(DateTime date) {
    const List<String> namaBulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final String hari = date.day.toString().padLeft(2, '0');
    final String bulan = namaBulan[date.month - 1];
    final int tahun = date.year;
    return '$hari $bulan $tahun';
  }

  /// Mengambil Icon sesuai kategori transaksi
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.restaurant;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Hiburan':
        return Icons.sports_esports;
      case 'Gaji/Pemasukan':
        return Icons.account_balance_wallet;
      default:
        return Icons.category;
    }
  }

  /// Mengambil Warna sesuai kategori transaksi
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.blue;
      case 'Hiburan':
        return Colors.purple;
      case 'Gaji/Pemasukan':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }
}
