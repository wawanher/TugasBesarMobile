import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reseller_provider.dart';
import '../providers/product_provider.dart';
import '../models/reseller.dart';
import 'dart:math';

class ResellerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resellerProvider = Provider.of<ResellerProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resellers'),
      ),
      body: ListView.builder(
        itemCount: resellerProvider.resellers.length,
        itemBuilder: (ctx, index) {
          final reseller = resellerProvider.resellers[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                reseller.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('Contact: ${reseller.contactInfo}', style: TextStyle(fontSize: 16)),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  resellerProvider.removeReseller(reseller.id);
                },
              ),
              onTap: () {
                _showSellToResellerModal(context, productProvider, reseller);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddResellerModal(context, resellerProvider);
        },
      ),
    );
  }

  void _showAddResellerModal(BuildContext context, ResellerProvider resellerProvider) {
    final _formKey = GlobalKey<FormState>();
    String resellerName = '';
    String resellerContactInfo = '';

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
                  decoration: InputDecoration(labelText: 'Reseller Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reseller name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    resellerName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact Info'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact info';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    resellerContactInfo = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      resellerProvider.addReseller(
                        Reseller(
                          id: Random().nextInt(1000).toString(),
                          name: resellerName,
                          contactInfo: resellerContactInfo,
                        ),
                      );
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text('Add Reseller'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSellToResellerModal(BuildContext context, ProductProvider productProvider, Reseller reseller) {
    final _formKey = GlobalKey<FormState>();
    String productId = '';
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
                  'Sell to ${reseller.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Product'),
                  items: productProvider.products.map((product) {
                    return DropdownMenuItem<String>(
                      value: product.id,
                      child: Text(product.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    productId = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a product';
                    }
                    return null;
                  },
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
                      productProvider.updateProductStock(productId, quantity);
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text('Sell'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
