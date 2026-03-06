import 'package:dio/dio.dart';
import '../mappers/product_mapper.dart';
import '../../../../domain/entities/products.dart';

class ProductsDatasource {
  final Dio dio;
  ProductsDatasource(this.dio);

  Future<List<Product>> fetchProducts({int limit = 20, int offset = 0}) async {
    try {
      final response = await dio.get(
        '/products',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      final List<dynamic> data = response.data['data'] ?? [];

      return data.map((json) => ProductMapper.jsonToEntity(json)).toList();
    } catch (e) {
      throw Exception('Error al traer productos: $e');
    }
  }
}
