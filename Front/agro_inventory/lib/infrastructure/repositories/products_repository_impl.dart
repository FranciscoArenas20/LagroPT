import 'package:isar/isar.dart';
import '../../domain/entities/products.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_datasource.dart';
import '../models/product_db.dart';
import '../mappers/product_mapper.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsDatasource datasource;
  final Isar isar; // <--- Inyectamos Isar

  ProductsRepositoryImpl(this.datasource, this.isar);

  @override
  Future<List<Product>> getProducts({int offset = 0, int limit = 20}) async {
    try {
      // 1. Intentamos traer datos de la API (NestJS)
      final products = await datasource.fetchProducts(
        offset: offset,
        limit: limit,
      );

      // 2. GUARDADO AUTOMÁTICO: Si hay datos, los persistimos en Isar
      await isar.writeTxn(() async {
        for (final product in products) {
          final productDb = ProductMapper.entityToDb(product);
          await isar.productDbs.put(
            productDb,
          ); // .put inserta o actualiza por el @Index
        }
      });

      return products;
    } catch (e) {
      // 3. OFFLINE MODE: Si la API falla (backend apagado), leemos de Isar
      final localProductsDb = await isar.productDbs
          .where()
          .offset(offset)
          .limit(limit)
          .findAll();

      // Convertimos lo que hallamos en la DB a entidades de la UI
      return localProductsDb.map((db) => ProductMapper.dbToEntity(db)).toList();
    }
  }
}
