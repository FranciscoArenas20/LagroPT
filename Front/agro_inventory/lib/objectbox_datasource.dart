import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'domain/entities/products.dart';
import 'objectbox.g.dart';

class ObjectBoxDatasource {
  late Future<Store> _store;

  ObjectBoxDatasource() {
    _store = _openStore();
  }

  Future<Store> _openStore() async {
    final dir = await getApplicationDocumentsDirectory();
    final storePath = p.join(dir.path, 'objectbox');
    return openStore(directory: storePath);
  }

  // Guarda o actualiza productos
  Future<void> saveProducts(List<Product> products) async {
    final store = await _store;
    final box = store.box<Product>();
    box.putMany(products);
  }

  // Obtiene todo lo guardado
  Future<List<Product>> getCachedProducts() async {
    final store = await _store;
    final box = store.box<Product>();
    return box.getAll();
  }

  // Busqueda real en la base de datos local
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    final store = await _store;
    final box = store.box<Product>();

    final q = box
        .query(Product_.name.contains(query, caseSensitive: false))
        .build();

    final results = q.find();
    q.close();
    return results;
  }
}
