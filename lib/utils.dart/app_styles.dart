import 'package:flutter/material.dart';

class Styles {
  // static Color primaryColor = primary;
  static Color textBlack = const Color(0xFF1D1819);
  static Color bgColor = const Color(0xFFE0EEFB);
  static Color lightBlueColor = const Color(0xFFE0EEFB);
  static Color darkBlueColor = const Color(0xFF0866C6);
  static Color lightYellowColor = const Color(0xFFFFF582);
  static Color lightOrangeColor = const Color(0xFFF08519);
  static Color darkOrangeColor = const Color(0xFFE04006);
  static Color redColor = const Color(0xFFE62129);
  static Color whiteColor = const Color(0xFFFEFEFE);
  static Color greenColor = const Color(0xFF009B4C);
  static Color greyblueColor = const Color(0xFFECF5FC);

  // Text Theme
  static TextTheme textTheme = TextTheme(
    //Nama Employee
    headlineMedium: TextStyle(
      fontFamily: "Montserrat-Bold",
      height: 1.5,
      // fontWeight: FontWeight.w500,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 1.5,
      fontSize: 20,
      color: Colors.transparent,
      shadows: [
        Shadow(
          offset: const Offset(0, -3),
          color: Styles.whiteColor,
        )
      ],
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.solid,
      decorationColor: Styles.whiteColor,
    ),

    //Divisi - Jabatan
    headlineSmall: TextStyle(
      fontFamily: "Montserrat-Medium",
      color: Styles.whiteColor,
      fontSize: 12,
      textBaseline: TextBaseline.alphabetic,
    ),

    //Jam Flip
    // labelLarge: TextStyle(
    //   fontFamily: "BarlowCondensed",
    //   color: Styles.textBlack,
    //   fontSize: 110,
    //   letterSpacing: 10,
    // ),

    //Notifikasi belum absen
    bodySmall: TextStyle(
      fontFamily: "Montserrat-Regular",
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Styles.textBlack,
    ),

    //Slide Untuk Mengambil Absen
    bodyMedium: TextStyle(
      fontSize: 16,
      fontFamily: "Montserrat-Medium",
      color: Styles.whiteColor,
    ),

    //Tampilan Riwayat Presensi
    labelMedium: TextStyle(
      fontFamily: "Montserrat-Medium",
      fontSize: 20,
      color: Styles.whiteColor,
    ),
  );

  // Theme Data
  static ThemeData themeData() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: darkBlueColor,
      ),
      textTheme: textTheme,
    );
  }
}
