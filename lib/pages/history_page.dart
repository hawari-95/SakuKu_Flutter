import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/transaction_model.dart';

/// Halaman 4: Riwayat Transaksi Lengkap (/riwayat)
/// Menampilkan daftar transaksi yang sudah dicatat menggunakan ListView.builder
/// Dilengkapi dengan filter (Semua, Pemasukan, Pengeluaran) dan fitur hapus item.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final AppData _appData = AppData();

  // Filter aktif: 'semua', 'pemasukan', 'pengeluaran'
  String _activeFilter = 'semua';

  // Dialog konfirmasi untuk menghapus data transaksi
  void _confirmDelete(BuildContext context, TransactionModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Catatan?'),
        content: Text('Apakah Anda yakin ingin menghapus "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Hapus data dari AppData (State Management)
              _appData.deleteTransaction(item.id);
              Navigator.pop(ctx);
              // Notifikasi SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Catatan "${item.title}" telah dihapus'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appData,
      builder: (context, _) {
        // Ambil daftar transaksi sesuai filter yang dipilih
        final List<TransactionModel> allList = _appData.transactions;
        final List<TransactionModel> filteredList;

        if (_activeFilter == 'pemasukan') {
          filteredList =
              allList.where((item) => item.type == TransactionType.income).toList();
        } else if (_activeFilter == 'pengeluaran') {
          filteredList =
              allList.where((item) => item.type == TransactionType.expense).toList();
        } else {
          filteredList = allList;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text('Riwayat Transaksi'),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              // ===============================================================
              // 1. FILTER CHIPS (Semua, Pemasukan, Pengeluaran)
              // ===============================================================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    _buildFilterChip('Semua', 'semua', allList.length),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'Pemasukan',
                      'pemasukan',
                      allList
                          .where((item) => item.type == TransactionType.income)
                          .length,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'Pengeluaran',
                      'pengeluaran',
                      allList
                          .where((item) => item.type == TransactionType.expense)
                          .length,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

              // ===============================================================
              // 2. DAFTAR TRANSAKSI DENGAN LISTVIEW.BUILDER
              // ===============================================================
              Expanded(
                child: filteredList.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        // Jumlah elemen pada daftar transaksi
                        itemCount: filteredList.length,
                        // Builder membangun widget setiap baris transaksi secara efisien
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          final bool isIncome = item.isIncome;
                          final Color categoryColor =
                              AppData.getCategoryColor(item.category);
                          final IconData categoryIcon =
                              AppData.getCategoryIcon(item.category);

                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                children: [
                                  // Ikon Kategori
                                  CircleAvatar(
                                    backgroundColor:
                                        categoryColor.withValues(alpha: 0.15),
                                    radius: 22,
                                    child: Icon(
                                      categoryIcon,
                                      color: categoryColor,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Judul, Kategori, Tanggal, & Catatan
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${item.category} • ${AppData.formatTanggal(item.date)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                        if (item.notes != null &&
                                            item.notes!.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Catatan: ${item.notes}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontStyle: FontStyle.italic,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Nominal & Tombol Hapus
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        (isIncome ? '+' : '-') +
                                            AppData.formatRupiah(item.amount),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isIncome
                                              ? const Color(0xFF16A34A)
                                              : const Color(0xFFDC2626),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () =>
                                            _confirmDelete(context, item),
                                        borderRadius: BorderRadius.circular(6),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            size: 18,
                                            color: Color(0xFFEF4444),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          // Floating Action Button untuk cepat menuju Form Tambah Transaksi
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            tooltip: 'Tambah Transaksi',
            onPressed: () {
              // Navigasi ke Form Tambah Transaksi
              Navigator.pushNamed(context, '/tambah');
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  // Widget pembantu untuk Filter Chip
  Widget _buildFilterChip(String label, String filterValue, int count) {
    final bool isSelected = _activeFilter == filterValue;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      selectedColor: Colors.teal.shade50,
      backgroundColor: const Color(0xFFF1F5F9),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.teal.shade800 : const Color(0xFF475569),
      ),
      side: BorderSide(
        color: isSelected ? Colors.teal : Colors.transparent,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _activeFilter = filterValue;
          });
        }
      },
    );
  }

  // Tampilan ketika daftar transaksi masih kosong
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Catatan Transaksi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol (+) untuk menambahkan catatan pengeluaran atau pemasukan baru Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
