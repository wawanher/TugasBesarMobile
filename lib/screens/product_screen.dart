// lib/screens/product_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

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
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Stock: ${product.stock}\nPrice: \$${product.price}'),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                _sellProduct(context, productProvider, product);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Implement add product functionality
        },
      ),
    );
  }

  void _sellProduct(BuildContext context, ProductProvider productProvider, Product product) {
    if (product.stock > 0) {
      // Kurangi stok saat produk dijual
      productProvider.updateProductStock(product.id, product.stock - 1);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} sold to reseller'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} is out of stock'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
