import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/provider/Cart.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/EventBus.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:yrs_jdshop/services/SignService.dart';
import 'package:yrs_jdshop/services/userServices.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  Map defAddress = {};
  var _event;

  Cart cartProvider;
  @override
  void initState() {
    super.initState();
    _getDefaultAddress();
    _event = eventBus.on<AddressEvent>().listen((event) {
      _getDefaultAddress();
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._event.cancel();
  }

  _getDefaultAddress() async {
    Map userinfo = await UserServices.userInfo;
    var tempJson = {
      "uid": userinfo["_id"],
      "salt": userinfo["salt"],
    };
    String sign = SignService.getSign(tempJson).toString();
    var response = await Dio().get(
        "${Config.domain}api/oneAddressList?uid=${userinfo["_id"]}&sign=$sign");
    setState(() {
      defAddress =
          response.data["result"].isEmpty ? {} : response.data["result"][0];
    });
  }

  Widget checkOutItem(v) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
          width: 1,
          color: Colors.black12,
        )),
      ),
      child: Row(
        children: <Widget>[
          Container(
              height: SceenUtils(context).setHeight(170),
              padding: EdgeInsets.all(5),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  "https://dss0.baidu.com/73x1bjeh1BF3odCf/it/u=3641014378,3271834652&fm=85&s=CA12668D505617C814B0FD1C0300E0C1",
                  fit: BoxFit.cover,
                ),
              )),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${v["title"]}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left),
                ),
                Container(alignment: Alignment.centerLeft, child: Text("类别:")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${v["price"]}元",
                      style: TextStyle(color: Colors.red, fontSize: 22),
                    ),
                    Text("数量: ${v["count"]}")
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  _pay() async {
    // Map userinfo = await UserServices.userInfo;
    // var tempJson = {
    //   "uid": userinfo["_id"],
    //   "phone": defAddress["phone"],
    //   "address": defAddress["address"],
    //   "name": defAddress["name"],
    //   "all_price": "${cartProvider.allPrice.toStringAsFixed(1)}",
    //   "salt": userinfo["salt"],
    //   // "products": json.encode(cartProvider.cartList.values.where((v) {
    //   //   return v["check"];
    //   // }).toList()),
    // };
    // String sign = SignService.getSign(tempJson).toString();
    // tempJson["sign"] = sign;
    // var response =
    //     await Dio().post("${Config.domain}api/doOrder", data: tempJson);
    // setState(() {
    //   print(response.data);
    // });
    cartProvider.remove();
    Navigator.pushNamed(context, MyRoutes.pay);
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("结算"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
              children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.adderssAdd);
              },
              child: defAddress.isEmpty
                  ? ListTile(
                      leading: Icon(Icons.add_location),
                      title: Center(child: Text("添加收获地址")),
                      trailing: Icon(Icons.chevron_right),
                    )
                  : ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${defAddress["name"]}  ${defAddress["phone"]}"),
                          Text(
                            "${defAddress["address"]}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right),
                    ),
            ),
          ]
                ..add(SizedBox(height: 30))
                ..addAll(cartProvider.cartList.values.where((v) {
                  return v["check"];
                }).map((v) {
                  return checkOutItem(v);
                }))
                ..add(Text("  运费: 5"))
                ..add(Text("  立减:5"))
                ..add(Text("  总价: 100"))),
          Positioned(
              bottom: 0,
              width: SceenUtils(context).setWidth(750),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                      width: 1,
                      color: Colors.black12,
                    ))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: <Widget>[
                          Text("总价格: "),
                          Text(
                            "${cartProvider.allPrice}元",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      color: Colors.red,
                      onPressed: _pay,
                      child: Text(
                        "立即下单",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
