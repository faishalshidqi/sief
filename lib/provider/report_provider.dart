import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  ReportProvider();

  String? period;

  void updatePeriod(String value) {
    period = value;
    notifyListeners();
  }
}