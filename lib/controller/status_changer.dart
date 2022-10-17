import 'package:flutter/material.dart';

class StatusChanger extends ChangeNotifier {
  DateTime _sDate = DateTime.now();

  void addDate(DateTime sDate) {
    _sDate = sDate;

    notifyListeners();
  }

  DateTime get getUpdateDate => _sDate;
}
