import 'package:agro_inventory/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ProductsScreenState createState() => ProductsScreenState();
}

class ProductsScreenState extends ConsumerState<ProductsScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Escuchar scroll para la paginación infinita
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        // Llamar al notifier para cargar la siguiente página
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose(); // Limpieza para evitar fugas de memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Estado completo del listado
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // AppBar que flota y reacciona al scroll
          const SliverAppBar(
            title: Text('🚜 Inventario Agro'),
            floating: true,
            snap: true,
          ),

          // La lista de productos optimizada con Slivers
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = productsState.products[index];

                return ProductCard(product: product);
              },
              childCount: productsState
                  .products
                  .length, // Número total de productos en memoria
            ),
          ),

          // Spinner de carga al final de la lista si está cargando más
          if (productsState.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // Mensaje final
          if (productsState.isLastPage)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    'Has llegado al final del inventario agrícola',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
