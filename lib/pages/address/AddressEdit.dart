import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/services/EventBus.dart';
import 'package:yrs_jdshop/services/SignService.dart';
import 'package:yrs_jdshop/services/userServices.dart';
import 'package:yrs_jdshop/widget/JDButton.dart';

class AddressEdit extends StatefulWidget {
  @override
  _AddressEditState createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {
  TextEditingController firstTextEditingController;
  TextEditingController secondTextEditingController;
  TextEditingController thridTextEditingController;
  String loction = "省/市/区";

  @override
  void initState() {
    super.initState();
    firstTextEditingController = new TextEditingController();
    secondTextEditingController = new TextEditingController();
    thridTextEditingController = new TextEditingController();



    
  }

  @override
  void dispose() {
    super.dispose();
    firstTextEditingController.dispose();
    secondTextEditingController.dispose();
    thridTextEditingController.dispose();
  }

  _addAdress() async {
    Map userinfo = await UserServices.userInfo;
    var tempJson = {
      "uid": userinfo["_id"],
      "name": firstTextEditingController.text,
      "phone": secondTextEditingController.text,
      "address": "$loction${thridTextEditingController.text}",
      "salt": userinfo["salt"],
    };
    String sign = SignService.getSign(tempJson).toString();
    tempJson["sign"] = sign;
    var res =
        await Dio().post("${Config.domain}api/addAddress", data: tempJson);
    if (res.data["success"]) {
      eventBus.fire(AddressEvent());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("新增收货地址"),
        ),
        body: ListView(
          children: <Widget>[
            TextField(
              controller: firstTextEditingController,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "收货人姓名: ",
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
                  hintText: "手机号: ",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  )),
            ),
            Divider(),
            FlatButton(
                onPressed: () async {
                  Result res = await CityPickers.showCityPicker(
                      context: context,
                      cancelWidget:
                          Text("取消", style: TextStyle(color: Colors.red)),
                      confirmWidget:
                          Text("确定", style: TextStyle(color: Colors.red)));

                  if (res != null) {
                    setState(() {
                      loction =
                          "${res.provinceName} /${res.cityName} /${res.areaName}";
                    });
                  }
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_location),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("$loction"),
                    )
                  ],
                )),
            Divider(),
            TextField(
              controller: thridTextEditingController,
              autofocus: false,
              maxLines: 3,
              decoration: InputDecoration(
                  hintText: "详细地址: ",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  )),
            ),
            Divider(),
            JDButton(
                title: "增加", color: Colors.red, hight: 40, cellback: _addAdress)
          ],
        ));
  }
}
