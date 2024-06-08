import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reseller_provider.dart';

class ResellerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resellerProvider = Provider.of<ResellerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resellers'),
      ),
      body: ListView.builder(
        itemCount: resellerProvider.resellers.length,
        itemBuilder: (ctx, index) {
          final reseller = resellerProvider.resellers[index];
          return ListTile(
            title: Text(reseller.name),
            subtitle: Text('Contact: ${reseller.contactInfo}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                resellerProvider.removeReseller(reseller.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Implement add reseller functionality
        },
      ),
    );
  }
}
