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
    scrollController.addListener(() {
      // Solo pide mas productos si el buscador esta vacio
      if (ref.read(searchQueryProvider).isEmpty) {
        if ((scrollController.position.pixels + 400) >=
            scrollController.position.maxScrollExtent) {
          ref.read(productsProvider.notifier).loadNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final isSearching = ref.watch(searchQueryProvider).isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            title: const Text('Inventario'),
            floating: true,
            snap: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: const FlexibleSpaceBar(),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) =>
                        ref.read(searchQueryProvider.notifier).state = val,
                    decoration: const InputDecoration(
                      hintText: 'Buscar ',
                      prefixIcon: Icon(Icons.search, color: Colors.green),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Lista de productos (ya sea la total o la filtrada)
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = filteredProducts[index];
              return ProductCard(product: product);
            }, childCount: filteredProducts.length),
          ),

          // Spinner: Solo se muestra si carga y No hay busqueda
          if (productsState.isLoading && !isSearching)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // Mensaje final
          if (productsState.isLastPage && !isSearching)
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

          // Mensaje de no resultados
          if (filteredProducts.isEmpty && isSearching)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Center(
                  child: Text('No se encontraron productos coincidentes'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
