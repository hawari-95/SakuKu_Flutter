import 'package:flutter/material.dart';

import '../data/app_data.dart';

/// Halaman 1: Screen Login / Selamat Datang (/login)
/// Pengguna memasukkan nama pengguna untuk memulai aplikasi.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // GlobalKey digunakan untuk memvalidasi status Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller untuk membaca input teks dari pengguna
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _usernameController.dispose();
    super.dispose();
  }

  // Fungsi untuk memproses login dan navigasi ke Dashboard
  void _handleLogin() {
    // Validasi form: jika input lolos validasi, lakukan navigasi
    if (_formKey.currentState!.validate()) {
      final String enteredName = _usernameController.text.trim();

      // Simpan username ke AppData singleton
      AppData().setUserName(enteredName);

      // Tampilkan SnackBar sambutan singkat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat datang, $enteredName!'),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigasi Named Route ke Dashboard (/home)
      // Menggunakan pushReplacementNamed agar halaman login dihapus dari back-stack
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey, // Pasang formKey untuk validasi
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Ikon Aplikasi
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 48,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Judul Aplikasi
                  const Text(
                    'SakuKu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Sub-judul / Tagline
                  const Text(
                    'Aplikasi Catatan Keuangan Harian\nKelola uangmu dengan bijak dan praktis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Card Form Input
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 1,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFFDDEFEF)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Masuk ke Akun',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Form Field: Nama Pengguna
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Nama Pengguna',
                              hintText: 'Masukkan nama pengguna',
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.teal,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.teal,
                                  width: 2,
                                ),
                              ),
                            ),
                            // Validasi input form: tidak boleh kosong
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama pengguna tidak boleh kosong!';
                              }
                              if (value.trim().length < 3) {
                                return 'Nama minimal 3 karakter!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Tombol Masuk ke Beranda
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.login_rounded),
                              label: const Text(
                                'Masuk ke Beranda',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Catatan / Footer Info
                  const Center(
                    child: Text(
                      'Tugas Praktikum Pemrograman Mobile',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
