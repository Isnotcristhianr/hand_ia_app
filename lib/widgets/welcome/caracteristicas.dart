import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Caracteristicas {
  static Widget buildFeatures() {
    final features = [
      'Análisis con IA avanzada',
      'Resultados instantáneos',
      '100% privado y seguro',
    ];

    return Column(
      children: features.map((feature) => buildFeatureItem(feature)).toList(),
    );
  }

  static Widget buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
