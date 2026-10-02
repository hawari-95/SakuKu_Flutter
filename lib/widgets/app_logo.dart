import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool inverted; // true = latar putih, ikon teal (dipakai di atas latar teal)

  const AppLogo({super.key, this.size = 40, this.inverted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: inverted ? Colors.white : Colors.teal.shade700,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        color: inverted ? Colors.teal : Colors.white,
        size: size * 0.55,
      ),
    );
  }
}