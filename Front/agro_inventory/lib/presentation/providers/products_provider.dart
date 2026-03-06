import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/products.dart';
import '../../domain/repositories/products_repository.dart';
import '../../infrastructure/repositories/products_repository_impl.dart';
import '../../infrastructure/datasources/products_datasource.dart';
import '../../objectbox_datasource.dart';

// Providers de Infraestructura
final objectBoxProvider = Provider((ref) => ObjectBoxDatasource());

final dioProvider = Provider(
  (ref) =>
      Dio(BaseOptions(baseUrl: 'https://lagropt-production.up.railway.app')),
);

final productsRepositoryProvider = Provider((ref) {
  final datasource = ProductsDatasource(ref.watch(dioProvider));
  return ProductsRepositoryImpl(datasource);
});

// Estado del Provider
class ProductsState {
  final List<Product> products;
  final int offset;
  final bool isLoading;
  final bool isLastPage;
  final String searchQuery;
  final bool hasError;

  ProductsState({
    this.products = const [],
    this.offset = 0,
    this.isLoading = false,
    this.isLastPage = false,
    this.searchQuery = '',
    this.hasError = false,
  });

  ProductsState copyWith({
    List<Product>? products,
    int? offset,
    bool? isLoading,
    bool? isLastPage,
    String? searchQuery,
    bool? hasError,
  }) =>
      ProductsState(
        products: products ?? this.products,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        isLastPage: isLastPage ?? this.isLastPage,
        searchQuery: searchQuery ?? this.searchQuery,
        hasError: hasError ?? this.hasError,
      );
}

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository repository;
  final ObjectBoxDatasource objectBox;

  ProductsNotifier({required this.repository, required this.objectBox})
      : super(ProductsState()) {
    loadNextPage();
  }

  Future<void> retry() async {
    state = state.copyWith(hasError: false, isLoading: true);
    await loadNextPage();
  }

  void searchProducts(String query) async {
    state = state.copyWith(searchQuery: query, hasError: false);

    if (query.isEmpty) {
      final cache = await objectBox.getCachedProducts();
      state = state.copyWith(products: cache, isLoading: false);
      return;
    }

    final results = await objectBox.searchProducts(query);
    state = state.copyWith(
      products: results,
      isLoading: false,
      isLastPage: true,
    );
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage || state.searchQuery.isNotEmpty)
      return;

    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final newProducts = await repository.getProducts(
        offset: state.offset,
        limit: 30,
      );

      if (newProducts.isEmpty) {
        state = state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      await objectBox.saveProducts(newProducts);

      state = state.copyWith(
        isLoading: false,
        products: [...state.products, ...newProducts],
        offset: state.offset + 30,
        hasError: false,
      );
    } catch (e) {
      final localData = await objectBox.getCachedProducts();

      if (state.products.isEmpty && localData.isEmpty) {
        state = state.copyWith(isLoading: false, hasError: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          products: state.products.isEmpty ? localData : state.products,
          hasError: false,
        );
      }
    }
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    final repository = ref.watch(productsRepositoryProvider);
    final objectBox = ref.watch(objectBoxProvider);
    return ProductsNotifier(repository: repository, objectBox: objectBox);
  },
);

final filteredProductsProvider = Provider((ref) {
  return ref.watch(productsProvider).products;
});
