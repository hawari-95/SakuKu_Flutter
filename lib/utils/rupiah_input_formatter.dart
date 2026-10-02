import 'package:flutter/services.dart';


/// Memformat input angka otomatis dengan titik ribuan.
/// Contoh: ketik 10000 -> tampil 10.000
class RupiahInputFormatter extends TextInputFormatter {
  static const int _maxDigits = 12; // batas aman: sampai ratusan miliar

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Ambil hanya angka (huruf, spasi, titik, koma dibuang)
    final String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return const TextEditingValue(text: '');
    if (digits.length > _maxDigits) return oldValue;

    final String formatted = format(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// "10000" -> "10.000"
  static String format(String digits) {
    final String clean = int.parse(digits).toString(); // buang nol di depan
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && (clean.length - i) % 3 == 0) buffer.write('.');
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  /// "10.000" -> 10000.0 (dipakai saat validasi dan menyimpan)
  static double parse(String text) {
    return double.tryParse(text.replaceAll('.', '').trim()) ?? 0;
  }
}