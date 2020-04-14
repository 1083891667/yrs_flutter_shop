import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/MyToast.dart';
import 'package:yrs_jdshop/widget/JDButton.dart';

class ResgisterSecond extends StatefulWidget {
  final Map arguments;
  const ResgisterSecond({Key key, this.arguments}) : super(key: key);
  @override
  _ResgisterSecondState createState() => _ResgisterSecondState();
}

class _ResgisterSecondState extends State<ResgisterSecond> {
  int time = 10;

  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = new TextEditingController();
    _showTimer();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  _showTimer() {
    if (time != 10) {
      sendCode();
    }
    setState(() {
      time = 10;
    });
    new Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        time--;
      });
      if (time <= 0) {
        timer.cancel();
      }
    });
  }

  sendCode() async {
    var res = await Dio().post("${Config.domain}api/sendCode",
        data: {"tel": widget.arguments["tel"]});
    if (res.data["success"]) {
      print(res.data);
    } else {
      MyToast.showCenterShortToast(res.data["message"]);
    }
  }

  vilidatacode() async {
    var res = await Dio().post("${Config.domain}api/validateCode", data: {
      "tel": widget.arguments["tel"],
      "code": textEditingController.text,
    });

    if (res.data["success"]) {
      Navigator.pushNamed(context, MyRoutes.resgisterThrid, arguments: {
        "tel": widget.arguments["tel"],
        "code": textEditingController.text,
      });
    } else {
      MyToast.showCenterShortToast(res.data["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用用户注册第二步"),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 5),
          Text("    输入手机${widget.arguments["tel"]}收到的验证码: "),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: "请输入验证码: ",
                      labelStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              RaisedButton(
                onPressed: time > 0 ? () {} : _showTimer,
                child: time > 0 ? Text("$time秒后重发") : Text("重新发送"),
              )
            ],
          ),
          Divider(),
          SizedBox(height: 20),
          JDButton(
            color: Colors.red,
            title: "下一步",
            hight: 40,
            cellback: vilidatacode,
          )
        ],
      ),
    );
  }
}
