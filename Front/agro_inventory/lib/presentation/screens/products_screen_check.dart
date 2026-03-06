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
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).loadNextPage();
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
    // Estado general y la lista ya filtrada
    final productsState = ref.watch(productsProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('InventAgro'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: TextField(
              onChanged: (value) {
                // LLAMADA ACTIVA AL BUSCADOR
                ref.read(productsProvider.notifier).searchProducts(value);
              },
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // BANNER DE ERROR / REINTENTO
          if (productsState.hasError)
            Container(
              width: double.infinity,
              color: Colors.orange.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Sin conexión. Mostrando datos locales.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(productsProvider.notifier).retry(),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('REINTENTAR'),
                  ),
                ],
              ),
            ),

          // LISTADO DE PRODUCTOS
          Expanded(
            child: (productsState.isLoading && filteredProducts.isEmpty)
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                ? const Center(child: Text('No se encontraron productos'))
                : ListView.builder(
                    controller: scrollController,
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
          ),

          // INDICADOR DE CARGA AL FINAL (SCROLL INFINITO)
          if (productsState.isLoading && filteredProducts.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}
