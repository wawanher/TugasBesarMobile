// lib/providers/stock_provider.dart
import 'package:flutter/material.dart';
import '../models/stock.dart';

class StockProvider with ChangeNotifier {
  List<Stock> _stocks = [];

  List<Stock> get stocks => _stocks;

  void addStock(Stock stock) {
    _stocks.add(stock);
    notifyListeners();
  }

  void removeStock(String id) {
    _stocks.removeWhere((stock) => stock.id == id);
    notifyListeners();
  }

  List<Stock> getStockForProduct(String productId) {
    return _stocks.where((stock) => stock.productId == productId).toList();
  }
}
