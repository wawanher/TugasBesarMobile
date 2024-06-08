// lib/providers/reseller_provider.dart
import 'package:flutter/material.dart';
import '../models/reseller.dart';

class ResellerProvider with ChangeNotifier {
  List<Reseller> _resellers = [];

  List<Reseller> get resellers => _resellers;

  void addReseller(Reseller reseller) {
    _resellers.add(reseller);
    notifyListeners();
  }

  void removeReseller(String id) {
    _resellers.removeWhere((reseller) => reseller.id == id);
    notifyListeners();
  }
}
