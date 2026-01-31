import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';

class BrandMark extends StatelessWidget {
  final Color textColor;
  final double logoHeight;

  const BrandMark({
    super.key,
    required this.textColor,
    required this.logoHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          kLogoWhiteAsset,
          height: logoHeight,
          errorBuilder: (_, __, ___) => Icon(Icons.school, color: textColor),
        ),
        const SizedBox(width: 10),
        Text(
          kBrandName,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
