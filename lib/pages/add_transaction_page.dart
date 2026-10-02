import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/transaction_model.dart';
import '../utils/rupiah_input_formatter.dart';

/// Halaman 3: Form Tambah Transaksi (/tambah)
/// Pengguna dapat menginput transaksi berupa pemasukan atau pengeluaran
/// lengkap dengan judul, nominal, kategori, dan tanggal.
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  // GlobalKey untuk kontrol dan validasi Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController untuk mengelola input teks
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // State lokal untuk tipe transaksi (Default: Pengeluaran)
  TransactionType _selectedType = TransactionType.expense;

  // State lokal untuk kategori (Default: Makanan)
  String _selectedCategory = 'Makanan';

  // State lokal untuk tanggal transaksi (Default: Hari ini)
  DateTime _selectedDate = DateTime.now();

  // Pilihan kategori yang tersedia sesuai spesifikasi
  final List<String> _expenseCategories = ['Makanan', 'Transportasi', 'Hiburan', 'Lainnya'];
  final List<String> _incomeCategories = ['Gaji/Pemasukan', 'Uang Saku', 'Hadiah', 'Lainnya'];

  @override
  void dispose() {
    // Membersihkan controller ketika widget dihancurkan dari widget tree
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Menampilkan dialog pemilihan tanggal (DatePicker)
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fungsi simpan transaksi setelah lolos validasi form
  void _saveTransaction() {
    // 1. Memeriksa validasi form
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text.trim();
      final double amount = RupiahInputFormatter.parse(_amountController.text);

      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nominal harus berupa angka lebih dari 0!'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // 2. Buat objek TransactionModel baru
      final newTransaction = TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        amount: amount,
        type: _selectedType,
        category: _selectedCategory,
        date: _selectedDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      // 3. Simpan ke AppData (State Management lokal)
      AppData().addTransaction(newTransaction);

      // 4. Beri feedback notifikasi ke pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transaksi "${newTransaction.title}" berhasil disimpan!',
          ),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 2),
        ),
      );

      // 5. Navigasi kembali ke halaman sebelumnya (pop)
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCategories = _selectedType == TransactionType.expense
        ? _expenseCategories
        : _incomeCategories;

    // Pastikan kategori yang dipilih valid dengan tipe transaksi saat ini
    if (!currentCategories.contains(_selectedCategory)) {
      _selectedCategory = currentCategories.first;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Pasang formKey
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================================================
              // 1. PILIHAN TIPE TRANSAKSI (PEMASUKAN / PENGELUARAN)
              // ===============================================================
              const Text(
                'Tipe Transaksi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Tombol Tipe: Pengeluaran
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedType = TransactionType.expense;
                          _selectedCategory = 'Makanan';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _selectedType == TransactionType.expense
                            ? Colors.red.shade50
                            : Colors.white,
                        side: BorderSide(
                          color: _selectedType == TransactionType.expense
                              ? Colors.red
                              : Colors.grey.shade300,
                          width: _selectedType == TransactionType.expense ? 2 : 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_upward_rounded,
                        color: _selectedType == TransactionType.expense
                            ? Colors.red
                            : Colors.grey,
                      ),
                      label: Text(
                        'Pengeluaran',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedType == TransactionType.expense
                              ? Colors.red
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol Tipe: Pemasukan
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedType = TransactionType.income;
                          _selectedCategory = 'Gaji/Pemasukan';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _selectedType == TransactionType.income
                            ? Colors.green.shade50
                            : Colors.white,
                        side: BorderSide(
                          color: _selectedType == TransactionType.income
                              ? Colors.green
                              : Colors.grey.shade300,
                          width: _selectedType == TransactionType.income ? 2 : 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        color: _selectedType == TransactionType.income
                            ? Colors.green
                            : Colors.grey,
                      ),
                      label: Text(
                        'Pemasukan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedType == TransactionType.income
                              ? Colors.green
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // 2. INPUT JUDUL / KETERANGAN
              // ===============================================================
              const Text(
                'Judul / Nama Transaksi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Misal: Makan Siang, Bensin, Gaji Pokok',
                  prefixIcon: const Icon(Icons.edit_note_rounded, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                // Validasi: Tidak boleh kosong
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul transaksi wajib diisi!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // 3. INPUT NOMINAL (RUPIAH)
              // ===============================================================
              const Text(
                'Nominal (Rp)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  hintText: '0',
                  prefixIcon: const Icon(Icons.payments_outlined, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                // Validasi: Harus berupa angka dan tidak boleh kosong
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nominal wajib diisi!';
                  }
                  if (RupiahInputFormatter.parse(value) <= 0) {
                    return 'Nominal harus lebih dari 0!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // 4. DROPDOWN KATEGORI (Makanan, Transportasi, Hiburan, dll)
              // ===============================================================
              const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    AppData.getCategoryIcon(_selectedCategory),
                    color: AppData.getCategoryColor(_selectedCategory),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                items: currentCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // 5. INPUT TANGGAL TRANSAKSI
              // ===============================================================
              const Text(
                'Tanggal Transaksi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 20, color: Colors.teal),
                          const SizedBox(width: 12),
                          Text(
                            AppData.formatTanggal(_selectedDate),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1E293B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Ubah',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ===============================================================
              // 6. TOMBOL SIMPAN TRANSAKSI
              // ===============================================================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Simpan Transaksi',
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
    );
  }
}
