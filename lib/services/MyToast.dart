import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  static void showLongToast(String str) {
    Fluttertoast.showToast(
      msg: "$str",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void showColoredToast(String str) {
    Fluttertoast.showToast(
        msg: "$str",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  static void showShortToast(String str) {
    Fluttertoast.showToast(
        msg: "$str", toastLength: Toast.LENGTH_SHORT, timeInSecForIos: 1);
  }

  static void showTopShortToast(String str) {
    Fluttertoast.showToast(
        msg: "$str",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1);
  }

  static void showCenterShortToast(String str) {
    Fluttertoast.showToast(
        msg: "$str",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1);
  }

  static void cancelToast() {
    Fluttertoast.cancel();
  }
}
