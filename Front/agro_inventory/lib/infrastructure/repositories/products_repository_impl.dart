import '../../domain/entities/products.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_datasource.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource datasource;

  ProductsRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts({int limit = 20, int offset = 0}) {
    return datasource.fetchProducts(limit: limit, offset: offset);
  }
}
