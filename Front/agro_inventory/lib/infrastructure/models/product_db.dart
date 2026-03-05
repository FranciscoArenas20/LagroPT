import 'package:isar/isar.dart';

// Este archivo se generará automáticamente después
part 'product_db.g.dart';

@collection
class ProductDb {
  Id isarId = Isar.autoIncrement; // ID interno de Isar

  @Index(unique: true, replace: true)
  final String id; // El ID que viene de tu NestJS (UUID o String)

  final String name;
  final String categoryName;
  final double price;
  final String imageUrl;

  ProductDb({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.price,
    required this.imageUrl,
  });
}
