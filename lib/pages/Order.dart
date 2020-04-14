import 'package:flutter/material.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的订单"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(height: 40),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(title: Text("订单: 142565867064uy54t2")),
                    Divider(),
                    ListTile(
                        title: Text("data"),
                        leading: Image.network(
                            "https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1208538952,1443328523&fm=26&gp=0.jpg"),
                        trailing: Text("x2")),
                    ListTile(
                      title: Text("合计: 121313"),
                      trailing: RaisedButton(
                        onPressed: () {},
                        child: Text("申请售后"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            width: SceenUtils(context).setWidth(750),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(onTap: () {}, child: Text("data")),
                InkWell(onTap: () {}, child: Text("data")),
                InkWell(onTap: () {}, child: Text("data")),
                InkWell(onTap: () {}, child: Text("data")),
                InkWell(onTap: () {}, child: Text("data")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
