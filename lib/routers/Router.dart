import 'package:flutter/material.dart';
import 'package:yrs_jdshop/pages/CheckOut.dart';
import 'package:yrs_jdshop/pages/Login.dart';
import 'package:yrs_jdshop/pages/Order.dart';
import 'package:yrs_jdshop/pages/ProductContent.dart';
import 'package:yrs_jdshop/pages/ProductList.dart';
import 'package:yrs_jdshop/pages/Register/ResgisterFirst.dart';
import 'package:yrs_jdshop/pages/Register/ResgisterSecond.dart';
import 'package:yrs_jdshop/pages/Register/ResgisterThird.dart';
import 'package:yrs_jdshop/pages/Search.dart';
import 'package:yrs_jdshop/pages/address/AdderssAdd.dart';
import 'package:yrs_jdshop/pages/address/AddressEdit.dart';
import 'package:yrs_jdshop/pages/address/AddressList.dart';
import 'package:yrs_jdshop/pages/pay.dart';
import 'package:yrs_jdshop/pages/tabs/Category.dart';
import 'package:yrs_jdshop/pages/tabs/tabs.dart';

class MyRoutes {
  static String tabs = "/";
  static String productList = "/productList";
  static String seach = "/seach";
  static String product = "/productContent";
  static String categoryPage = "/categoryPage";
  static String login = "/loginPage";
  static String resgisterFirst = "/resgisterFirst";
  static String resgisterSecond = "/resgisterSecond";
  static String resgisterThrid = "/resgisterThrid";
  static String checkoutpage = "/checkoutpage";
  static String adderssAdd = "/adderssAdd";
  static String addressEdit = "/addressEdit";
  static String addressList = "/addressList";
  static String pay = "/pay";
  static String order = "/order";
}

//配置路由
final routes = {
  MyRoutes.categoryPage: (context) => CategoryPage(),
  MyRoutes.order: (context) => OrderPage(),
  MyRoutes.pay: (context) => PayPage(),
  MyRoutes.adderssAdd: (context) => AdderssAdd(),
  MyRoutes.addressEdit: (context) => AddressEdit(),
  MyRoutes.addressList: (context, {arguments}) =>
      AddressList(arguments: arguments),
  MyRoutes.tabs: (context) => Tabs(),
  MyRoutes.checkoutpage: (context) => CheckOutPage(),
  MyRoutes.product: (context, {arguments}) =>
      ProductContentPPage(arguments: arguments),
  MyRoutes.productList: (context, {arguments}) =>
      ProductListPage(arguments: arguments),
  MyRoutes.seach: (context) => SearchPage(),
  MyRoutes.login: (context) => LoginPage(),
  MyRoutes.resgisterFirst: (context) => ResgisterFirst(),
  MyRoutes.resgisterSecond: (context, {arguments}) =>
      ResgisterSecond(arguments: arguments),
  MyRoutes.resgisterThrid: (context, {arguments}) =>
      ResgisterThrid(arguments: arguments),
};
//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
