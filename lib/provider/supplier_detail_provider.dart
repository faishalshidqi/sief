import 'package:flutter/material.dart';

class SupplierDetailProvider extends ChangeNotifier {
  SupplierDetailProvider();

  bool isEditMode = false;
  String? name;
  String? phone;
  String? address;
  DateTime? updatedAt;

  void updateEditMode(bool value) {
    isEditMode = value;
    notifyListeners();
  }

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

  void updateUpdatedAt(DateTime value) {
    updatedAt = value;
    notifyListeners();
  }
}
