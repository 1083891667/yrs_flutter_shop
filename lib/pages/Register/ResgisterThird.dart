import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/pages/tabs/Tabs.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/MyToast.dart';
import 'package:yrs_jdshop/services/Storage.dart';
import 'package:yrs_jdshop/services/userServices.dart';
import 'package:yrs_jdshop/widget/JDButton.dart';

class ResgisterThrid extends StatefulWidget {
  final Map arguments;
  ResgisterThrid({Key key, this.arguments}) : super(key: key);
  @override
  _ResgisterThridState createState() => _ResgisterThridState();
}

class _ResgisterThridState extends State<ResgisterThrid> {
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

  _doRegister() async {
    if (firstTextEditingController.text != secondTextEditingController.text) {
      MyToast.showCenterShortToast("两次密码不一样");
      return;
    }
    var res = await Dio().post("${Config.domain}api/register", data: {
      "tel": widget.arguments["tel"],
      "code": widget.arguments["code"],
      "password": firstTextEditingController.text,
    });
    if (res.data["success"]) {
      print(res.data);
      Storage.setMap("userinfo", res.data["userinfo"][0]);
      Navigator.pushNamedAndRemoveUntil(
          context, MyRoutes.tabs, (route) => route == null);
    } else {
      MyToast.showCenterShortToast(res.data["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册第三步"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: firstTextEditingController,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "输入密码: ",
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
              decoration: InputDecoration(
                  hintText: "再次输入密码: ",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  )),
            ),
            Divider(),
            SizedBox(height: 20),
            JDButton(
                color: Colors.red,
                title: "完成",
                hight: 40,
                cellback: _doRegister)
          ],
        ),
      ),
    );
  }
}
