import 'package:agro_inventory/infrastructure/models/product_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'config/theme/app_theme.dart';
import 'presentation/screens/products_screen_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([ProductDbSchema], directory: dir.path);
  runApp(
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const MainApp(),
    ),
  );
}

// Un provider simple para acceder a Isar desde cualquier parte
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError(); // Se sobreescribe en el main
});

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agro Inventory',
      // Usamos el tema que ya tenías configurado
      theme: AppTheme().getTheme(),
      // Aquí es donde mostramos tu pantalla de productos
      home: const ProductsScreen(),
    );
  }
}
