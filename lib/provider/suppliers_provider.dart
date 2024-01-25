import 'package:flutter/material.dart';

class SuppliersProvider extends ChangeNotifier {
  SuppliersProvider();

  String? name;
  String? phone;
  String? address;

  void updateName(String value) {
    name = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    phone = value;
    notifyListeners();
  }

  void updateAddress(String value) {
    address = value;
    notifyListeners();
  }
}
