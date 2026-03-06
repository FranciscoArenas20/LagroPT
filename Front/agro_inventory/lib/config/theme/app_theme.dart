import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 191, 255, 201),
        appBarTheme: const AppBarTheme(centerTitle: true),
      );
}
