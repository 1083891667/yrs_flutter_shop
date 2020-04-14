import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/model/ProductModel.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:yrs_jdshop/services/SearchServices.dart';
import 'package:yrs_jdshop/widget/widget.dart';

class ProductListPage extends StatefulWidget {
  final Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPastState createState() => _ProductListPastState();
}

class _ProductListPastState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  int _page;
  List<ProductItemModel> _productList;
  ScrollController _scrollController;
  bool more = true;
  List _subHeaderList = [
    {"id": 0, "title": "综合", "fileds": "all_", "sort": -1},
    {"id": 1, "title": "销量", "fileds": 'salecount_', "sort": -1},
    {"id": 2, "title": "价格", "fileds": 'price_', "sort": -1},
    {"id": 3, "title": "筛选"}
  ];
  int _selectHeaderId;
  TextEditingController textEditingController;
  bool hasdata = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_addListener);
    textEditingController = TextEditingController();
    textEditingController.text = widget.arguments["keyWrods"] ?? "";
    _page = 1;
    _selectHeaderId = 0;
    _productList = [];
    _getProductList();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    textEditingController.dispose();
  }

  //监听事件
  _addListener() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 20) {
      if (more) {
        _page++;
        _getProductList();
      }
    }
  }

  _getProductList() async {
    String uri =
        "${Config.domain}api/plist?cid=${widget.arguments["id"]}&page=$_page&sort=${_subHeaderList[_selectHeaderId]["fileds"]}${_subHeaderList[_selectHeaderId]["sort"]}";

    if (widget.arguments["keyWrods"] != null) {
      uri =
          "${Config.domain}api/plist?search=${widget.arguments["keyWrods"]}&page=$_page&sort=${_subHeaderList[_selectHeaderId]["fileds"]}${_subHeaderList[_selectHeaderId]["sort"]}";
    }
    if (more) {
      more = false;
      var res = await Dio().get(uri);
      ProductModel data = ProductModel.fromJson(res.data);
      if (data.result.length < 10) {
        _scrollController.removeListener(_addListener);
      }
      setState(() {
        _productList.addAll(data.result);
        this.hasdata = _productList.isNotEmpty;
      });
      more = true;
    }
  }

  Widget _showMore(int index) {
    if (_scrollController.hasListeners) {
      return index == this._productList.length - 1 ? LoadingWidget() : Text("");
    } else {
      return index == this._productList.length - 1
          ? Text("-----我是有底线的-------")
          : Text(""); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, size: 28, color: Colors.black87),
              onPressed: () {
                SearchServices.setHistoryData(textEditingController.text);
                widget.arguments["keyWrods"] = this.textEditingController.text;
                _scrollController.addListener(_addListener);
                _productList = [];
                _page = 1;
                _getProductList();
              })
        ],
        title: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                controller: textEditingController,
                autofocus: false,
                decoration: InputDecoration.collapsed(
                    hintText: "点击搜索",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                        gapPadding: 0)),
              ))
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: Text("data"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _subHeadWidght(context),
            Divider(
              height: 8,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: _productListWidght(),
            )),
          ],
        ),
      ),
    );
  }

//筛选导航
  Container _subHeadWidght(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SceenUtils(context).setHeight(70),
      child: Row(
          children: _subHeaderList.map((value) {
        return Expanded(
            child: InkWell(
          onTap: () {
            if (value["id"] == 3) {
              this._scaffold.currentState.openEndDrawer();
              return;
            }
            setState(() {
              _selectHeaderId = value["id"];
              _subHeaderList[_selectHeaderId]["sort"] =
                  -1 * _subHeaderList[_selectHeaderId]["sort"];
              _scrollController.addListener(_addListener);
              _productList = [];
              _page = 1;
              _getProductList();
            });
          },
          child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "${value["title"]}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color:
                            _selectHeaderId == value["id"] ? Colors.red : null),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: _selectHeaderId == value["id"]
                        ? Icon(
                            _subHeaderList[_selectHeaderId]["sort"] == 1
                                ? Icons.arrow_drop_down
                                : Icons.arrow_drop_up,
                            color: Colors.red,
                          )
                        : Text(""),
                  ),
                )
              ],
            ),
          ),
        ));
      }).toList()),
    );
  }

//商品列表
  Widget _productListWidght() {
    if (!hasdata) {
      return Text("没数据");
    }

    if (_productList.isEmpty) {
      return LoadingWidget();
    }

    return ListView.builder(
        controller: _scrollController ?? new ScrollController(),
        itemCount: _productList.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: SceenUtils(context).setWidth(180),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                            "${Config.domain}${_productList[index].pic.replaceAll("\\", "/")}",
                            fit: BoxFit.cover)),
                  ),
                  Expanded(
                      child: Container(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      height: SceenUtils(context).setWidth(180),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${_productList[index].title}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "¥${_productList[index].price}",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
              Divider(),
              _showMore(index)
            ],
          );
        });
  }
}
