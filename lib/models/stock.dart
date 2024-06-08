// lib/models/stock.dart
class Stock {
  final String id;
  final String productId;
  final int quantity;
  final DateTime date;

  Stock({required this.id, required this.productId, required this.quantity, required this.date});
}
