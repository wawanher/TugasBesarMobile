// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [
    Product(id: '1', name: 'Product 1', stock: 10, price: 20.0),
    Product(id: '2', name: 'Product 2', stock: 5, price: 30.0),
    Product(id: '3', name: 'Product 3', stock: 8, price: 25.0),
  ];

  List<Product> get products => _products;

  void updateProductStock(String id, int newStock) {
    final productIndex = _products.indexWhere((prod) => prod.id == id);
    if (productIndex != -1) {
      _products[productIndex].stock = newStock;
      notifyListeners();
    }
  }
}
