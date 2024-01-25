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

  /*Future<dynamic> login() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      _state = ResultState.hasData;
      notifyListeners();
      return _message = 'Autentikasi Berhasil. Selamat Datang!';
        } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    }
    catch (error) {
      _state = ResultState.error;
      notifyListeners();
      _message = error.toString();
      return _message;
    }
  }

  Future<dynamic> logout() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      await _auth.signOut();
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    }
  }

  void checkIsLoggedIn(BuildContext context) {
    User? user = _auth.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, DashboardPage.routeName);
    }
  }*/
}
