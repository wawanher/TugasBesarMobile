import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../providers/product_provider.dart';
import '../models/stock.dart';
import 'dart:math';

class StockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks'),
      ),
      body: ListView.builder(
        itemCount: stockProvider.stocks.length,
        itemBuilder: (ctx, index) {
          final stock = stockProvider.stocks[index];
          final product = productProvider.products.firstWhere((prod) => prod.id == stock.productId);
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Quantity: ${stock.quantity} - Date: ${stock.date}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                stockProvider.removeStock(stock.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddStockDialog(context, stockProvider, productProvider);
        },
      ),
    );
  }

  void _showAddStockDialog(BuildContext context, StockProvider stockProvider, ProductProvider productProvider) {
    final _formKey = GlobalKey<FormState>();
    String? selectedProductId;
    int quantity = 0;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Stock'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                hint: Text('Select Product'),
                value: selectedProductId,
                onChanged: (newValue) {
                  selectedProductId = newValue;
                },
                items: productProvider.products.map((product) {
                  return DropdownMenuItem<String>(
                    value: product.id,
                    child: Text(product.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a product';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onSaved: (newValue) {
                  quantity = int.parse(newValue!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                stockProvider.addStock(
                  Stock(
                    id: Random().nextInt(1000).toString(),
                    productId: selectedProductId!,
                    quantity: quantity,
                    date: DateTime.now(),
                  ),
                );
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}