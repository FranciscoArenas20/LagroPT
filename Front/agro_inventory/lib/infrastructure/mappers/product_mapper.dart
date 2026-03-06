import '../../domain/entities/products.dart';

class ProductMapper {
  static Product jsonToEntity(Map<String, dynamic> json) => Product(
    id: json['id']?.toString() ?? '',
    name: json['name'] ?? 'Sin nombre',
    description: json['description'] ?? '',
    price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    category: (json['category'] is Map)
        ? (json['category']['name'] ?? 'General')
        : 'General',
    image: json['image'] ?? 'https://via.placeholder.com/150',
  );
}
