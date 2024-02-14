import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  UsersProvider();

  String? username;
  String? email;
  String? password;
  String? repeatPassword;
  String? role;

  List<String> roles = [
    'gudang',
    'kasir',
  ];

  void updateRole(String value) {
    role = value;
    notifyListeners();
  }

  void updateUsername(String value) {
    username = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updateRepeatPassword(String value) {
    repeatPassword = value;
    notifyListeners();
  }
}
