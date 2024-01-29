import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xff2e1503);
const Color secondaryColor = Color(0xff356859);

const Color primaryColor500 = Color(0xff652a0e);
const Color primaryColor100 = Color(0xff9a7b4f);

const Color secondaryColor50 = Color(0xffb9e4c9);

final TextTheme siefTextTheme = TextTheme(
  displayLarge: GoogleFonts.montserrat(
    fontSize: 98,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
  ),
  displayMedium: GoogleFonts.montserrat(
    fontSize: 61,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
  ),
  displaySmall:
      GoogleFonts.montserrat(fontSize: 49, fontWeight: FontWeight.w400),
  headlineMedium: GoogleFonts.montserrat(
    fontSize: 35,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  headlineSmall:
      GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w400),
  titleLarge: GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  titleMedium: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  ),
  titleSmall: GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  bodyLarge: GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyMedium: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  labelLarge: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  bodySmall: GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),
  labelSmall: GoogleFonts.montserrat(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);
