import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Importante instalarlo
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

    // Escuchamos el movimiento del scroll
    scrollController.addListener(() {
      // Si el usuario está a 400 pixeles del final, cargamos más
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
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
    // Ahora observamos el estado completo (lista, cargando, etc.)
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      // Usamos CustomScrollView para habilitar Slivers (mayor rendimiento)
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // AppBar que desaparece o flota al hacer scroll
          const SliverAppBar(
            title: Text('🚜 Inventario Agro'),
            floating: true,
            snap: true,
          ),

          // La lista optimizada
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = productsState.products[index];

              return ListTile(
                // IMPLEMENTACIÓN DE CACHED_NETWORK_IMAGE
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://tu-api.com/images/${product.id}.jpg", // Ajustar según tu backend
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(strokeWidth: 2),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.agriculture, color: Colors.green),
                  ),
                ),
                title: Text(product.name),
                subtitle: Text(product.category),
                trailing: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              );
            }, childCount: productsState.products.length),
          ),

          // Indicador de carga al final de la lista
          if (productsState.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // Espacio extra al final si ya no hay más productos
          if (productsState.isLastPage)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text('Has llegado al final del inventario'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
