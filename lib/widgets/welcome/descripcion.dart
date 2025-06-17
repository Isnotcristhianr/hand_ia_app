import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Descripcion {
  static Widget buildMainDescription() {
    return Text(
      'Utiliza inteligencia artificial avanzada para analizar las líneas de tu mano y obtener insights únicos sobre tu personalidad y futuro.',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white.withOpacity(0.8),
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}