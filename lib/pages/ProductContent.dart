import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/model/ProductContentModel.dart';
import 'package:yrs_jdshop/pages/productContent/ProductFirst.dart';
import 'package:yrs_jdshop/pages/productContent/ProductSecond.dart';
import 'package:yrs_jdshop/pages/productContent/ProductThird.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/EventBus.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:yrs_jdshop/widget/JDButton.dart';
import 'package:yrs_jdshop/widget/widget.dart';

class ProductContentPPage extends StatefulWidget {
  final Map arguments;
  ProductContentPPage({this.arguments});
  @override
  _ProductContentPPageState createState() => _ProductContentPPageState();
}

class _ProductContentPPageState extends State<ProductContentPPage> {
  ProductContentitem _productContentitem;

  @override
  void initState() {
    super.initState();
    _getProductDate();
  }

  _getProductDate() async {
    var res = await Dio()
        .get("${Config.domain}api/pcontent?id=${widget.arguments["id"]}");
    ProductContentModel data = ProductContentModel.fromJson(res.data);
    setState(() {
      this._productContentitem = data.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: SceenUtils(context).setWidth(400),
                  child: TabBar(
                    tabs: [
                      Tab(child: Text("商品")),
                      Tab(child: Text("详情")),
                      Tab(child: Text("评价")),
                    ],
                    indicatorColor: Colors.red,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                            SceenUtils(context).setWidth(600),
                            SceenUtils(context).setHeight(100),
                            SceenUtils(context).setWidth(10),
                            0),
                        items: [
                          PopupMenuItem(
                              child: Row(
                            children: <Widget>[
                              Icon(Icons.home),
                              Text("首页"),
                            ],
                          )),
                          PopupMenuItem(
                              child: Row(
                            children: <Widget>[
                              Icon(Icons.search),
                              Text("搜索"),
                            ],
                          ))
                        ]);
                  })
            ],
          ),
          body: _productContentitem != null
              ? Stack(
                  children: <Widget>[
                    TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ProductFirstPage(
                              productContentitem: this._productContentitem),
                          ProductSecondPage(
                              productContentitem: this._productContentitem),
                          ProductThirdPage(
                              productContentitem: this._productContentitem),
                        ]),
                    Positioned(
                        bottom: 0,
                        width: SceenUtils(context).setWidth(750),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.black26, width: 1))),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MyRoutes.categoryPage);
                                },
                                child: Container(
                                    padding: EdgeInsets.only(top: 5),
                                    width: 100,
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.shopping_cart),
                                        Text("购物车")
                                      ],
                                    )),
                              ),
                              Expanded(
                                  child: JDButton(
                                title: "加入购物车",
                                color: Color.fromRGBO(253, 1, 0, 0.9),
                                cellback: () {
                                  //广播
                                  eventBus.fire(ProductContentEvent());
                                },
                              )),
                              Expanded(
                                  child: JDButton(
                                title: "立即购买",
                                color: Color.fromRGBO(255, 165, 0, 0.9),
                                cellback: () {
                                  eventBus.fire(ProductContentEvent());
                                },
                              )),
                            ],
                          ),
                        ))
                  ],
                )
              : LoadingWidget()),
    );
  }
}
