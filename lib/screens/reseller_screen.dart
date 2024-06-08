import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reseller_provider.dart';
import '../models/reseller.dart';
import 'dart:math';

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
}
