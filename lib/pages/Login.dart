import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/EventBus.dart';
import 'package:yrs_jdshop/services/MyToast.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:yrs_jdshop/services/Storage.dart';
import 'package:yrs_jdshop/widget/JDButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController firstTextEditingController;
  TextEditingController secondTextEditingController;

  @override
  void initState() {
    super.initState();

    firstTextEditingController = new TextEditingController();
    secondTextEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    firstTextEditingController.dispose();
    secondTextEditingController.dispose();
  }

  _login() async {
    var res = await Dio().post("${Config.domain}api/doLogin", data: {
      "username": firstTextEditingController.text,
      "password": secondTextEditingController.text,
    });
    if (res.data["success"]) {
      print(res.data);
      Storage.setMap("userinfo", res.data["userinfo"][0]);
      eventBus.fire(UserLoginContentEvent());
      Navigator.pop(context);
    } else {
      MyToast.showCenterShortToast(res.data["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          Center(child: FlatButton(onPressed: () {}, child: Text("客服"))),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Center(
                child: Container(
              margin: EdgeInsets.only(top: 30, bottom: 30),
              height: SceenUtils(context).setHeight(160),
              width: SceenUtils(context).setWidth(160),
              child: Image.asset(
                "images/user.png",
                fit: BoxFit.cover,
              ),
            )),
            TextField(
              controller: firstTextEditingController,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "请输入账号",
                  labelText: "账号:",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  )),
            ),
            Divider(),
            TextField(
              controller: secondTextEditingController,
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "请输入密码",
                  labelText: "密码:",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                      gapPadding: 0)),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.resgisterFirst);
                  },
                  child: Text("新用户注册"),
                ),
                Text("忘记密码"),
              ],
            ),
            SizedBox(height: 20),
            JDButton(
              color: Colors.red,
              title: "登录",
              hight: 40,
              cellback: _login,
            )
          ],
        ),
      ),
    );
  }
}
