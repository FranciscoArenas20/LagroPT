import '../../domain/entities/products.dart';
import '../models/product_db.dart'; // Importa tu modelo de Isar

class ProductMapper {
  // 1. Lo que ya tenías: De JSON (API NestJS) a Entidad (UI)
  static Product jsonToEntity(Map<String, dynamic> json) => Product(
    id: json['id']?.toString() ?? '',
    name: json['name'] ?? 'Sin nombre',
    description: json['description'] ?? '',
    price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    categoryName: json['category']?['name'] ?? 'General',
    // Asegúrate de que tu entidad Product tenga imageUrl o agrégala aquí
    imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
  );

  // 2. NUEVO: De Isar (DB) a Entidad (UI)
  static Product dbToEntity(ProductDb db) => Product(
    id: db.id,
    name: db.name,
    price: db.price,
    categoryName: db.categoryName,
    imageUrl: db.imageUrl,
    description: '', // Isar puede no guardar la descripción si es muy pesada
  );

  // 3. NUEVO: De Entidad (UI) a Isar (DB) para guardar
  static ProductDb entityToDb(Product entity) => ProductDb(
    id: entity.id,
    name: entity.name,
    price: entity.price,
    categoryName: entity.categoryName,
    imageUrl: entity.imageUrl,
  );
}
