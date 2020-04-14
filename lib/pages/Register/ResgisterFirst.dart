import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/MyToast.dart';

import 'package:yrs_jdshop/widget/JDButton.dart';

class ResgisterFirst extends StatefulWidget {
  @override
  _ResgisterFirstState createState() => _ResgisterFirstState();
}

class _ResgisterFirstState extends State<ResgisterFirst> {
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  sendCode() async {
    RegExp reg = new RegExp(r"^1\d{10}$");
    bool b = reg.hasMatch(textEditingController.text);
    if (b) {
      var res = await Dio().post("${Config.domain}api/sendCode",
          data: {"tel": textEditingController.text});
      if (res.data["success"]) {
        Navigator.pushNamed(context, MyRoutes.resgisterSecond,
            arguments: {"tel": textEditingController.text});
      } else {
        MyToast.showCenterShortToast(res.data["message"]);
      }
    } else {
      MyToast.showCenterShortToast("手机号格式错误");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("用户注册第一步")),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: textEditingController,
            autofocus: false,
            decoration: InputDecoration(
                hintText: "请输入手机号: ",
                labelText: "手机号:",
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
            title: "下一步",
            hight: 40,
            cellback: () {
              sendCode();
            },
          )
        ],
      ),
    );
  }
}
