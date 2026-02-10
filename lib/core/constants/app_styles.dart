import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppStyles {
  static TextStyle leagueSpartan48 = GoogleFonts.leagueSpartan(
    fontSize: 48,
    fontWeight: FontWeight.w100,
    color: Colors.white,
    height: 0,
  );
  static TextStyle leagueSpartan24 = GoogleFonts.leagueSpartan(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 0,
  );
  static TextStyle leagueSpartan20 = GoogleFonts.leagueSpartan(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    height: 0,
  );
  static TextStyle leagueSpartan16 = GoogleFonts.leagueSpartan(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 0,
    color: Colors.black,
  );
  static TextStyle leagueSpartan12W600 = GoogleFonts.leagueSpartan(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle leagueSpartan12W300 = GoogleFonts.leagueSpartan(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.black,
  );
}
