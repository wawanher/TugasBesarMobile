// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.stock = 0,
  });
}
