import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider();

  bool isPasswordObscured = true;
  String? email;
  String? password;

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updatePasswordObscure(bool value) {
    isPasswordObscured = value;
    notifyListeners();
  }
}
