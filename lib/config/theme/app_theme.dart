import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

mixin AppTheme {
  static ThemeData get appTheme {
    return ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.grey, // Usamos gris como base para blanco y negro
      ).copyWith(
        primary: Colors.black, // Establecemos el color principal como negro
        surface: Colors.white, // Los fondos de superficie serán blancos
        onPrimary: Colors.white, // El texto sobre el color negro será blanco
        onSurface: Colors.black, // El texto sobre el color blanco será negro
      ),
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      // iconButtonTheme: IconButtonThemeData(
      //   style: IconButton.styleFrom(
      //     backgroundColor: Colors.black,
      //     foregroundColor: Colors.white,
      //   ),
      // ),
    );
  }
}
