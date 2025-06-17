import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget reutilizable para efectos cristal
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double height;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const GlassButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.height = 50,
    this.textColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: width ?? double.infinity,
        height: height,
        borderRadius: height / 2,
        blur: 15,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: textColor ?? Colors.white,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
