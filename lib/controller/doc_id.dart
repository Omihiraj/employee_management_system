import 'package:flutter/material.dart';

class DocId extends ChangeNotifier {
  String _docNo = "";

  void selectDoc(String no) {
    _docNo = no;

    notifyListeners();
  }

  String get getDocNo => _docNo;
}
