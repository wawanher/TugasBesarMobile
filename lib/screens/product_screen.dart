// lib/screens/product_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'dart:math';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
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
                  Text('Price: \$${product.price}', style: TextStyle(fontSize: 16)),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  productProvider.removeProduct(product.id);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddProductModal(context, productProvider);
        },
      ),
    );
  }

  void _showAddProductModal(BuildContext context, ProductProvider productProvider) {
    final _formKey = GlobalKey<FormState>();
    String productName = '';
    int productStock = 0;
    double productPrice = 0.0;

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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productStock = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productPrice = double.parse(value!);
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      productProvider.addProduct(
                        Product(
                          id: Random().nextInt(1000).toString(),
                          name: productName,
                          stock: productStock,
                          price: productPrice,
                        ),
                      );
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
