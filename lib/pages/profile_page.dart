import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../utils/rupiah_input_formatter.dart';

/// Halaman 5: Profil Pengguna dan Target Tabungan Harian (/profil)
/// Menampilkan identitas pengguna, pengelolaan target tabungan harian,
/// statistik keuangan, dan opsi Logout menuju Halaman Login.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AppData _appData = AppData();

  // Dialog untuk mengubah target tabungan harian
  void _showEditTargetDialog() {
    final TextEditingController targetController = TextEditingController(
      text: RupiahInputFormatter.format(
        _appData.dailySavingsTarget.toInt().toString(),
      ),
    );
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Atur Target Tabungan Harian'),
        content: Form(
          key: dialogFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tentukan berapa nominal uang yang ingin kamu tabung setiap harinya.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: targetController,
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                decoration: InputDecoration(
                  labelText: 'Target Tabungan (Rp)',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Target tidak boleh kosong!';
                  }
                  final numVal = RupiahInputFormatter.parse(val);
                  if (numVal <= 0) {
                    return 'Masukkan nominal yang valid (> 0)!';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (dialogFormKey.currentState!.validate()) {
                final double newTarget =
                    RupiahInputFormatter.parse(targetController.text);
                // Simpan target baru ke AppData
                _appData.setDailySavingsTarget(newTarget);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Target tabungan harian berhasil diperbarui!'),
                    backgroundColor: Colors.teal,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Dialog konfirmasi Logout
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Logout'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun ini dan kembali ke halaman login?',
        ),
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
              Navigator.pop(ctx); // Tutup dialog
              // Menghapus semua riwayat tumpukan navigasi dan kembali ke /login
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Keluar'),
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
        final totalTx = _appData.transactions.length;
        final saldo = _appData.totalBalance;
        final target = _appData.dailySavingsTarget;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text('Profil Pengguna'),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // =============================================================
                // 1. KARTU HEADER IDENTITAS PENGGUNA
                // =============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar Pengguna
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.teal.shade100,
                        child: Text(
                          _appData.userName.isNotEmpty
                              ? _appData.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Nama Pengguna
                      Text(
                        _appData.userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Pengguna SakuKu Aktif',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =============================================================
                // 2. KARTU TARGET TABUNGAN HARIAN
                // =============================================================
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.savings_rounded,
                                    color: Colors.amber,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Target Tabungan Harian',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.teal, size: 20),
                              tooltip: 'Ubah Target',
                              onPressed: _showEditTargetDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppData.formatRupiah(target),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Komitmen menabung per hari untuk menjaga stabilitas finansial Anda.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =============================================================
                // 3. STATISTIK AKUN KEUANGAN
                // =============================================================
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ringkasan Keuangan Anda',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildStatRow(
                          icon: Icons.receipt_long,
                          color: Colors.indigo,
                          label: 'Total Transaksi',
                          value: '$totalTx Catatan',
                        ),
                        const Divider(height: 20),
                        _buildStatRow(
                          icon: Icons.account_balance_wallet,
                          color: Colors.teal,
                          label: 'Sisa Saldo Kas',
                          value: AppData.formatRupiah(saldo),
                        ),
                        const Divider(height: 20),
                        _buildStatRow(
                          icon: Icons.calendar_month,
                          color: Colors.deepOrange,
                          label: 'Target Bulanan (Est.)',
                          value: AppData.formatRupiah(target * 30),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =============================================================
                // 4. INFORMASI APLIKASI
                // =============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Aplikasi',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Nama Aplikasi', 'SakuKu (Keuangan Harian)'),
                      _buildInfoRow('Versi', '1.0.0 (Release)'),
                      _buildInfoRow('Platform', 'Flutter Mobile (Local Storage)'),
                      _buildInfoRow('Mata Kuliah', 'Praktikum Pemrograman Mobile'),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =============================================================
                // 5. TOMBOL LOGOUT (KELUAR KE /login)
                // =============================================================
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _confirmLogout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'Keluar / Logout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          radius: 16,
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          Text(
            val,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
