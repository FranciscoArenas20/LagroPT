import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.red,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
