import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/pages/tabs/zhibo.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/EventBus.dart';
import 'package:yrs_jdshop/services/userServices.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Map userInfo;
  bool login = false;
  var _event;
  @override
  void initState() {
    super.initState();
    _event = eventBus.on<UserLoginContentEvent>().listen((event) {
      getUserInfo();
    });
    getUserInfo();
    _demo();
  }

  @override
  void dispose() {
    super.dispose();
    this._event.cancel();
  }

  getUserInfo() async {
    login = await UserServices.userInfoState;
    userInfo = await UserServices.userInfo;
    setState(() {});
  }

  loginOut() async {
    await UserServices.romoveUserInfo();
    userInfo.clear();
    login = false;
    setState(() {});
  }

  _demo() async {
    Dio dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    var res = await dio
        .post("https://pro.vtrading.com/VtradingApp/systemV2/getUsdCnyRate");
    print(res.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/user_bg.jpg"), fit: BoxFit.cover)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: ClipOval(
                  child: Image.asset(
                    "images/user.png",
                    fit: BoxFit.cover,
                    height: 80,
                  ),
                ),
              ),
              login
                  ? Expanded(
                      child: InkWell(
                      onLongPress: loginOut,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "用户名: ${userInfo["username"]}",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "普通会员",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ))
                  : Expanded(
                      child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MyRoutes.login);
                      },
                      child: Text(
                        "登录/注册",
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, MyRoutes.order);
          },
          child: ListTile(
            leading: Icon(Icons.assignment, color: Colors.red),
            title: Text("全部订单"),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment, color: Colors.green),
          title: Text("待付款"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.local_car_wash, color: Colors.orange),
          title: Text("待收货"),
        ),
        Container(
            width: double.infinity,
            height: 10,
            color: Color.fromRGBO(242, 242, 242, 0.9)),
        ListTile(
          leading: Icon(Icons.favorite, color: Colors.lightGreen),
          title: Text("我的收藏"),
        ),
        Divider(),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ZhiboPage()));
          },
          child: ListTile(
            leading: Icon(Icons.people, color: Colors.black54),
            title: Text("直播"),
          ),
        ),
        Divider(),
      ],
    ));
  }
}
