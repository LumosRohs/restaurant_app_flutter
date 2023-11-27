import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFD67BFF);
const Color secondaryColor = Color(0xFFFFFFFF);
const Color darkPrimaryColor = Color(0xFF000000);
const Color darkSecondaryColor = Color(0xff64ffda);

final TextTheme myTextTheme = TextTheme(
  displayLarge: GoogleFonts.inter(
      fontSize: 92, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.inter(
      fontSize: 57, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  displaySmall: GoogleFonts.inter(fontSize: 46, fontWeight: FontWeight.w400),
  headlineMedium: GoogleFonts.inter(
      fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: 0.25),
  headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600),
  titleLarge: GoogleFonts.inter(
      fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
  titleSmall: GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyMedium: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.25),
  bodySmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),
  labelSmall: GoogleFonts.inter(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: secondaryColor,
      ),
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  appBarTheme: const AppBarTheme(elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: darkPrimaryColor,
        onPrimary: Colors.black,
        secondary: darkSecondaryColor,
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: myTextTheme,
  appBarTheme: const AppBarTheme(elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
);
