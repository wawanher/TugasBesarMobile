// lib/screens/stock_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'package:myapp/models/product.dart';

class StockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Stocks'),
      ),
      body: ListView.builder(
        itemCount: productProvider.products.length,
        itemBuilder: (ctx, index) {
          final product = productProvider.products[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  Text('Stock: ${product.stock}', style: TextStyle(fontSize: 16)),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_box, color: Colors.green),
                onPressed: () {
                  _showAddStockModal(context, productProvider, product);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddStockModal(BuildContext context, ProductProvider productProvider, Product product) {
    final _formKey = GlobalKey<FormState>();
    int quantity = 0;

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Add Stock to ${product.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    quantity = int.parse(value!);
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      productProvider.updateProductStock(product.id, quantity);
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text('Add Stock'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
