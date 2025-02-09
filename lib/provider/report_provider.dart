import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  ReportProvider();

  bool isSortInc = true;
  int? day;
  int? month;
  int? year;

  void updateSortInc(bool value) {
    isSortInc = value;
    notifyListeners();
  }

  void updateDay(int value) {
    day = value;
    notifyListeners();
  }

  void updateMonth(int value) {
    month = value;
    notifyListeners();
  }

  void updateYear(int value) {
    year = value;
    notifyListeners();
  }
}
