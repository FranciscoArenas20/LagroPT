import '../entities/products.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({int limit = 20, int offset = 0});
}
