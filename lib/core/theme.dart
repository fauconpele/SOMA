import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

ThemeData buildSomaTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.interTextTheme(),
  );
}
