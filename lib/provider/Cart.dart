import 'package:flutter/material.dart';
import 'package:yrs_jdshop/services/Storage.dart';

class Cart with ChangeNotifier {
  Map _cartList = {};
  bool _isCheckAll = false;
  num _allPrice = 0;

  Map get cartList => this._cartList;
  bool get isCheckAll => this._isCheckAll;
  num get allPrice => this._allPrice;

  Cart() {
    init();
  }

  init() async {
    _cartList = await Storage.getMap("777");
    checkState();
    totalPrices();
    notifyListeners();
  }

  changeCartData() async {
    checkState();
    totalPrices();
    await Storage.setMap("777", _cartList);
    notifyListeners();
  }

  checkState() {
    bool isCheckall = _cartList.values.any((v) {
      return v["check"] == false;
    });
    this._isCheckAll = !isCheckall;
  }

  checkAll(bool value) async {
    _cartList.forEach((k, v) {
      v["check"] = value;
    });
    _isCheckAll = value;
    totalPrices();
    await Storage.setMap("777", _cartList);
    notifyListeners();
  }

  totalPrices() {
    num i = 0;
    _cartList.forEach((k, v) {
      if (v["check"]) {
        i += num.parse(v["price"].toString()) * v["count"];
      }
    });
    _allPrice = i;
    notifyListeners();
  }

  remove() async {
    _cartList.removeWhere((k, v) {
      return v["check"];
    });
    await changeCartData();
  }
}
