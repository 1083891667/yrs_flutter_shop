import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/model/FocusModel.dart';
import 'package:yrs_jdshop/model/ProductModel.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<FocusItemModel> _focusData = [];
  List<ProductItemModel> _sutData = [];
  List<ProductItemModel> _huoData = [];

  @override
  void initState() {
    super.initState();
    _getFocusDate();
    _getSutProductData();
    _getHotProductData();
  }

  @override
  bool get wantKeepAlive => true;

  //标签组件
  Widget _titleWidget(String title) {
    return Container(
      padding: EdgeInsets.only(left: SceenUtils(context).setWidth(10)),
      margin: EdgeInsets.only(left: SceenUtils(context).setWidth(10)),
      child: Text(
        "$title",
        style: TextStyle(color: Colors.black45),
      ),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: Colors.red, width: SceenUtils(context).setWidth(6)))),
    );
  }

  //轮播图
  Widget _swiperWidget() {
    return Container(
      child: _focusData.length > 0
          ? AspectRatio(
              aspectRatio: 2 / 1,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return new Image.network(
                    "${Config.domain}${_focusData[index].pic.replaceAll("\\", "/")}",
                    fit: BoxFit.fill,
                  );
                },
                itemCount: _focusData.length,
                pagination: new SwiperPagination(),
                autoplay: true,
              ))
          : Text("加载中"),
    );
  }

//猜你喜欢
  Widget _sutProductList() {
    if (_sutData.length == 0) {
      return Text("加载中");
    }

    return Container(
        margin: EdgeInsets.only(
            left: SceenUtils(context).setWidth(10),
            right: SceenUtils(context).setWidth(10)),
        height: SceenUtils(context).setHeight(180),
        child: ListView.builder(
          itemCount: _sutData.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(right: SceenUtils(context).setWidth(10)),
                  height: SceenUtils(context).setHeight(140),
                  width: SceenUtils(context).setWidth(140),
                  child: Image.network(
                    "${Config.domain}${_sutData[index].pic.replaceAll("\\", "/")}",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                    width: SceenUtils(context).setWidth(140),
                    height: SceenUtils(context).setHeight(34),
                    child: Text(
                      "¥${_sutData[index].price}",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ))
              ],
            );
          },
        ));
  }

  //热门推荐
  Widget _getHotPru() {
    List<Widget> _getHotPru() {
      return _huoData.map((value) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, MyRoutes.product,
                arguments: {"id": value.sId});
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1)),
            width: (MediaQuery.of(context).size.width - 30) / 2,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    child: AspectRatio(
                      //图片大小
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        "${Config.domain}${value.pic.replaceAll("\\", "/")}",
                        fit: BoxFit.cover,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "${value.title}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "¥${value.price}",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          )),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "¥${value.oldPrice}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();
    }

    return Container(
        padding: EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 10,
          spacing: 10,
          children: _getHotPru(),
        ));
  }

//获取轮播图数据
  _getFocusDate() async {
    var res = await Dio().get("${Config.domain}api/focus");
    FocusModel data = FocusModel.fromJson(res.data);
    setState(() {
      _focusData = data.result;
    });
  }

//获取猜你喜欢数据
  _getSutProductData() async {
    var res = await Dio().get("${Config.domain}api/plist?is_hot=1");
    ProductModel data = ProductModel.fromJson(res.data);
    setState(() {
      _sutData = data.result;
    });
  }

//获取热门推荐的数据
  _getHotProductData() async {
    var res = await Dio().get("${Config.domain}api/plist?is_best=1");
    ProductModel data = ProductModel.fromJson(res.data);
    setState(() {
      _huoData = data.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, MyRoutes.seach);
          },
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                SizedBox(width: 10),
                Text(
                  "搜索",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
        ),
        leading:
            IconButton(icon: Icon(Icons.center_focus_weak), onPressed: () {}),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.message, size: 28, color: Colors.black87),
              onPressed: () {})
        ],
      ),
      body: ListView(
        children: <Widget>[
          _swiperWidget(),
          SizedBox(height: SceenUtils(context).setHeight(20)),
          _titleWidget("猜你喜欢"),
          SizedBox(height: SceenUtils(context).setHeight(20)),
          _sutProductList(),
          SizedBox(height: SceenUtils(context).setHeight(20)),
          _titleWidget("热门推荐"),
          _getHotPru()
        ],
      ),
    );
  }
}
