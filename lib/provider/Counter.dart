import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _count = 0;
  incCount(int i) {
    this._count+=i;
    notifyListeners();
  }
  int get count => _count;
}
