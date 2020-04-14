import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/EventBus.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:yrs_jdshop/services/SignService.dart';
import 'package:yrs_jdshop/services/userServices.dart';
import 'package:yrs_jdshop/widget/JDButton.dart';

class AdderssAdd extends StatefulWidget {
  @override
  _AdderssAddState createState() => _AdderssAddState();
}

class _AdderssAddState extends State<AdderssAdd> {
  List addressList = [];

  @override
  void initState() {
    super.initState();
    _getAdderss();
  }

  _getAdderss() async {
    Map userinfo = await UserServices.userInfo;
    var tempJson = {
      "uid": userinfo["_id"],
      "salt": userinfo["salt"],
    };
    String sign = SignService.getSign(tempJson).toString();

    var response = await Dio().get(
        "${Config.domain}api/addressList?uid=${userinfo["_id"]}&sign=$sign");
    setState(() {
      addressList = response.data["result"];
    });
  }

  //修改默认地址

  _changeDefAdderss(id) async {
    Map userinfo = await UserServices.userInfo;
    var tempJson = {
      "uid": userinfo["_id"],
      "salt": userinfo["salt"],
      "id": "$id",
    };
    String sign = SignService.getSign(tempJson).toString();
    tempJson["sign"] = sign;
    await Dio()
        .post("${Config.domain}api/changeDefaultAddress", data: tempJson);
    Navigator.pop(context);
  }

  _delAddress(id) async {
    Map userinfo = await UserServices.userInfo;
    var tempJson = {
      "uid": userinfo["_id"],
      "salt": userinfo["salt"],
      "id": "$id",
    };
    String sign = SignService.getSign(tempJson).toString();
    tempJson["sign"] = sign;
    var api = '${Config.domain}api/deleteAddress';
    await Dio().post(api, data: tempJson);
    _getAdderss(); //删除收货地址完成后重新获取列表
  }

  @override
  void dispose() {
    super.dispose();
    eventBus.fire(AddressEvent());
  }

  _showDelAlertDialog(id) async {
    await showDialog(
        barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示信息!"),
            content: Text("您确定要删除吗?"),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () async {
                  //执行删除操作
                  this._delAddress(id);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加收货地址"),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
              itemCount: addressList.length,
              itemBuilder: (con, index) {
                return ListTile(
                  leading: addressList[index]["default_address"] == 1
                      ? Icon(Icons.check, color: Colors.red)
                      : null,
                  title: InkWell(
                    onTap: () {
                      _changeDefAdderss(addressList[index]["_id"]);
                    },
                    onLongPress: () {
                      _showDelAlertDialog(addressList[index]["_id"]);
                    },
                    child: Text(
                        "${addressList[index]["name"]}  ${addressList[index]["phone"]}"),
                  ),
                  subtitle: InkWell(
                    child: Text("${addressList[index]["address"]}"),
                    onTap: () {
                      _changeDefAdderss(addressList[index]["_id"]);
                    },
                    onLongPress: () {
                      _showDelAlertDialog(addressList[index]["_id"]);
                    },
                  ),
                  trailing: InkWell(
                    child: Icon(Icons.edit, color: Colors.blue),
                    onTap: () {
                      Navigator.pushNamed(context, MyRoutes.addressList,
                          arguments: {
                            "name": addressList[index]["name"],
                            "phone": addressList[index]["phone"],
                            "address": addressList[index]["address"],
                            "id": addressList[index]["_id"],
                          }).then((v) {
                        _getAdderss();
                      });
                    },
                  ),
                );
              }),
          Positioned(
            bottom: 0,
            width: SceenUtils(context).setWidth(750),
            child: JDButton(
              title: "+ 新增收货地址",
              color: Colors.red,
              hight: 40,
              cellback: () {
                Navigator.pushReplacementNamed(context, MyRoutes.addressEdit);
              },
            ),
          )
        ],
      ),
    );
  }
}
