import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider();

  String? query;

  void updateQuery(String value) {
    query = value;
    notifyListeners();
  }
}
