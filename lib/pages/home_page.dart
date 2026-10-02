import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/transaction_model.dart';
import '../widgets/app_logo.dart';

/// Halaman 2: Dashboard Beranda (/home)
/// Menampilkan Ringkasan Saldo Total, Pemasukan, Pengeluaran,
/// Tombol Pintasan Navigasi, dan Transaksi Terkini.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppData _appData = AppData();

  // Helper fungsi untuk navigasi ke halaman lain dan me-refresh tampilan saat kembali
  Future<void> _navigateTo(String routeName) async {
    // Navigasi menggunakan Named Route (Navigator.pushNamed)
    await Navigator.pushNamed(context, routeName);
    // Memanggil setState agar UI diperbarui jika ada data transaksi baru yang ditambahkan
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appData,
      builder: (context, _) {
        final double saldoTotal = _appData.totalBalance;
        final double totalPemasukan = _appData.totalIncome;
        final double totalPengeluaran = _appData.totalExpense;
        final List<TransactionModel> recentTransactions =
            _appData.transactions.take(4).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.teal,
            elevation: 0,
            automaticallyImplyLeading: false, // Menghilangkan tombol back default
            title: Row(
              children: [
                const AppLogo(size: 40, inverted: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat Datang,',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        _appData.userName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Tombol pintas ke Halaman Profil
              IconButton(
                tooltip: 'Profil Pengguna',
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () => _navigateTo('/profil'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =============================================================
                // 1. KARTU UTAMA: RINGKASAN SALDO TOTAL & PEMASUKAN/PENGELUARAN
                // =============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sisa Saldo Anda',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Aktif',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Nominal Saldo Total (Dinamis)
                      Text(
                        AppData.formatRupiah(saldoTotal),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 16),

                      // Baris Pemasukan & Pengeluaran
                      Row(
                        children: [
                          // Kolom Pemasukan
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: Color(0xFF86EFAC),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Pemasukan',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        AppData.formatRupiah(totalPemasukan),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Pemisah Vertikal
                          Container(
                            height: 32,
                            width: 1,
                            color: Colors.white24,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),

                          // Kolom Pengeluaran
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Color(0xFFFCA5A5),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Pengeluaran',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        AppData.formatRupiah(totalPengeluaran),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // =============================================================
                // 2. TOMBOL PINTASAN NAVIGASI (QUICK ACTIONS)
                // =============================================================
                const Text(
                  'Menu Pintasan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    // Pintasan: Tambah Transaksi (/tambah)
                    Expanded(
                      child: _buildShortcutCard(
                        icon: Icons.add_circle_outline_rounded,
                        color: Colors.teal.shade700,
                        label: 'Tambah',
                        sublabel: 'Catat uang',
                        onTap: () => _navigateTo('/tambah'),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Pintasan: Riwayat Transaksi (/riwayat)
                    Expanded(
                      child: _buildShortcutCard(
                        icon: Icons.receipt_long_rounded,
                        color: Colors.teal.shade700,
                        label: 'Riwayat',
                        sublabel: 'Daftar catatan',
                        onTap: () => _navigateTo('/riwayat'),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Pintasan: Profil Pengguna (/profil)
                    Expanded(
                      child: _buildShortcutCard(
                        icon: Icons.person_outline_rounded,
                        color: Colors.teal.shade700,
                        label: 'Profil',
                        sublabel: 'Target harian',
                        onTap: () => _navigateTo('/profil'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =============================================================
                // 3. KARTU TARGET TABUNGAN HARIAN
                // =============================================================
                Card(
                  elevation: 1,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.savings_rounded,
                                color: Colors.amber,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Target Tabungan Harian',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    AppData.formatRupiah(
                                        _appData.dailySavingsTarget),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => _navigateTo('/profil'),
                              child: const Text('Atur Target'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _appData.savingsProgress,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tersimpan hari ini: ${AppData.formatRupiah(_appData.todaySavings)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              '${(_appData.savingsProgress * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =============================================================
                // 4. TRANSAKSI TERKINI
                // =============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Transaksi Terkini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _navigateTo('/riwayat'),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (recentTransactions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.inbox_rounded,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'Belum ada transaksi.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = recentTransactions[index];
                      return _buildTransactionTile(item);
                    },
                  ),

                const SizedBox(height: 70), // Spasi agar tidak tertutup FAB
              ],
            ),
          ),
          // Floating Action Button untuk cepat mencatat transaksi
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _navigateTo('/tambah'),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text(
              'Tambah Transaksi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  // Widget pembantu untuk tombol pintasan
  Widget _buildShortcutCard({
    required IconData icon,
    required Color color,
    required String label,
    required String sublabel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.18),
              radius: 24,
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk menampilkan item transaksi
  Widget _buildTransactionTile(TransactionModel item) {
    final bool isIncome = item.isIncome;
    final Color categoryColor = AppData.getCategoryColor(item.category);
    final IconData categoryIcon = AppData.getCategoryIcon(item.category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: categoryColor.withValues(alpha: 0.15),
            radius: 22,
            child: Icon(categoryIcon, color: categoryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.category} • ${AppData.formatTanggal(item.date)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            (isIncome ? '+' : '-') + AppData.formatRupiah(item.amount),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIncome ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }
}
