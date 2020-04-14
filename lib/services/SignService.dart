import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignService {
  static getSign(Map kkkk) {
    List s = kkkk.keys.toList();
    s.sort();
    String str = "";
    for (var i = 0; i < s.length; i++) {
      str += "${s[i]}${kkkk[s[i]]}";
    }
    return md5.convert(utf8.encode(str));
  }
}
