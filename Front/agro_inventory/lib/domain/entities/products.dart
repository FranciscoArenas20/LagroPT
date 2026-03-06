import 'package:objectbox/objectbox.dart';

@Entity()
class Product {
  @Id()
  int obId;

  @Unique()
  String id;
  String name;
  String description;
  double price;
  String category;
  String image;

  Product({
    this.obId = 0,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });
}
