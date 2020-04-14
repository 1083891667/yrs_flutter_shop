import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yrs_jdshop/pages/cart/CartItem.dart';
import 'package:yrs_jdshop/provider/Cart.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/MyToast.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:yrs_jdshop/services/userServices.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isEdit = false;
  Cart cartProvider;
  @override
  void initState() {
    super.initState();
  }

  _doCheckOut() async {
    if (cartProvider.allPrice == 0) {
      MyToast.showCenterShortToast("没选中任何数据!");
      return;
    }

    if (!(await UserServices.userInfoState)) {
      MyToast.showCenterShortToast("没登录!");
      Navigator.pushNamed(context, MyRoutes.login);
      return;
    }

    Navigator.pushNamed(context, MyRoutes.checkoutpage);
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("购物车"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.launch),
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                });
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 30),
              child: ListView(
                children: cartProvider.cartList.values.map((v) {
                  return CartItem(v);
                }).toList(),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 0,
              height: SceenUtils(context).setHeight(78),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: 1, color: Colors.black12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: cartProvider.isCheckAll,
                          onChanged: (value) {
                            cartProvider.checkAll(value);
                          },
                          activeColor: Colors.pink,
                        ),
                        Text("全选"),
                        isEdit
                            ? Text("")
                            : Text(
                                "    共: ${cartProvider.allPrice}元",
                                style: TextStyle(color: Colors.red),
                              )
                      ],
                    ),
                    isEdit
                        ? RaisedButton(
                            color: Colors.red,
                            onPressed: () async {
                              await cartProvider.remove();
                            },
                            child: Text(
                              "移除",
                              style: TextStyle(color: Colors.white),
                            ))
                        : RaisedButton(
                            color: Colors.red,
                            onPressed: _doCheckOut,
                            child: Text(
                              "结算",
                              style: TextStyle(color: Colors.white),
                            )),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
