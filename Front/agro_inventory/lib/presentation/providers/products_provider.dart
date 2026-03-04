import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../infrastructure/datasources/products_datasource.dart';
import '../../domain/entities/products.dart';

final dioProvider = Provider(
  (ref) => Dio(BaseOptions(baseUrl: 'http://localhost:3000')),
);

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final dio = ref.watch(dioProvider);
  final datasource = ProductsDatasource(dio);
  return datasource.fetchProducts(limit: 20, offset: 0);
});
