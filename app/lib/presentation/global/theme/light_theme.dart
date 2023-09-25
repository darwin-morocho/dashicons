import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final _baseTheme = ThemeData.light(useMaterial3: true);

ThemeData get lightTheme => _baseTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xfff0f0f0),
      textTheme: GoogleFonts.jetBrainsMonoTextTheme(_baseTheme.textTheme).copyWith(),
      colorScheme: _baseTheme.colorScheme.copyWith(
        primary: AppColors.dark,
        background: const Color(0xfff0f0f0),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(AppColors.darkLight),
          overlayColor: MaterialStatePropertyAll(Color.fromARGB(113, 20, 45, 63)),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
        ),
      ),
      dialogBackgroundColor: const Color(0xfff2f2f2),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xfff2f2f2),
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        hoverColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 10,
        ),
        labelStyle: TextStyle(
          color: AppColors.dark,
        ),
        hintStyle: TextStyle(
          color: Colors.black26,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.blue,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.red,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.red,
          ),
        ),
       
      ),
    );
