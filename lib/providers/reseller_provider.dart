import 'package:flutter/material.dart';
import '../models/reseller.dart';

class ResellerProvider with ChangeNotifier {
  List<Reseller> _resellers = [];

  List<Reseller> get resellers => _resellers;

  void addReseller(Reseller reseller) {
    _resellers.add(reseller);
    notifyListeners();
  }

  void updateReseller(Reseller updatedReseller) {
    final index = _resellers.indexWhere((res) => res.id == updatedReseller.id);
    if (index != -1) {
      _resellers[index] = updatedReseller;
      notifyListeners();
    }
  }

  void removeReseller(String id) {
    _resellers.removeWhere((res) => res.id == id);
    notifyListeners();
  }
}