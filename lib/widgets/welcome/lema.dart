import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Lema {
  static Widget buildLema() {
    return Text(
      'La sabiduría de tu destino,\nen la palma de tu mano.',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.white.withValues(alpha: 0.9),
        height: 1.4,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
