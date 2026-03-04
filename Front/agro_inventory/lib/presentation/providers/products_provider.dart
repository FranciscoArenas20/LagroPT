import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/products.dart';
import '../../domain/repositories/products_repository.dart';
import '../../infrastructure/repositories/products_repository_impl.dart';
import '../../infrastructure/datasources/products_datasource.dart';

// Provider de Dio
final dioProvider = Provider(
  (ref) => Dio(BaseOptions(baseUrl: 'http://localhost:3000')),
);

// Provider del Repositorio
final productsRepositoryProvider = Provider((ref) {
  final datasource = ProductsDatasource(ref.watch(dioProvider));
  return ProductsRepositoryImpl(datasource);
});

// Estado de la pantalla
class ProductsState {
  final List<Product> products;
  final int offset;
  final bool isLoading;
  final bool isLastPage;

  ProductsState({
    this.products = const [],
    this.offset = 0,
    this.isLoading = false,
    this.isLastPage = false,
  });

  ProductsState copyWith({
    List<Product>? products,
    int? offset,
    bool? isLoading,
    bool? isLastPage,
  }) => ProductsState(
    products: products ?? this.products,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    isLastPage: isLastPage ?? this.isLastPage,
  );
}

// Notificador
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository repository;

  ProductsNotifier({required this.repository}) : super(ProductsState()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    try {
      final newProducts = await repository.getProducts(
        offset: state.offset,
        limit: 20,
      );

      if (newProducts.isEmpty) {
        state = state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        products: [...state.products, ...newProducts],
        offset: state.offset + 20,
      );
    } catch (e) {
      // Detenemos el loading para poder reintentar
      state = state.copyWith(isLoading: false);
    }
  }
}

// Provider final
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    final repository = ref.watch(productsRepositoryProvider);
    return ProductsNotifier(repository: repository);
  },
);
