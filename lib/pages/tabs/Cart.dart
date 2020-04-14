import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/model/CateModel.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with AutomaticKeepAliveClientMixin {
  int _seleteIndex = 0;
  List<CateItemModel> _firstList = [];
  List<CateItemModel> _sencendList = [];
  @override
  void initState() {
    super.initState();
    _getFirstData();
  }

  @override
  bool get wantKeepAlive => true;

  _getFirstData() async {
    var res = await Dio().get("${Config.domain}api/pcate");
    CateModel data = CateModel.fromJson(res.data);
    setState(() {
      _firstList = data.result;
    });
    _getSencondData(_firstList[0].sId);
  }

  _getSencondData(var id) async {
    var res = await Dio().get("${Config.domain}api/pcate?pid=$id");
    CateModel data = CateModel.fromJson(res.data);
    setState(() {
      _sencendList = data.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double vul = (MediaQuery.of(context).size.width * 0.75 - 30) /
        3 /
        ((MediaQuery.of(context).size.width * 0.75 - 30) / 3 +
            SceenUtils(context).setHeight(30));

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
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: ListView.builder(
                  itemCount: _firstList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              _seleteIndex = index;
                            });
                            _getSencondData(_firstList[index].sId);
                          },
                          child: Container(
                              color: index == this._seleteIndex
                                  ? Colors.grey[100]
                                  : null,
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: SceenUtils(context).setHeight(84),
                              child: Text("${_firstList[index].title}")),
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    );
                  }),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: vul,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _sencendList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MyRoutes.productList,
                          arguments: {"id": _sencendList[index].sId},
                        );
                      },
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Image.network(
                              "${Config.domain}${_sencendList[index].pic.replaceAll("\\", "/")}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            height: SceenUtils(context).setHeight(30),
                            child: Text("${_sencendList[index].title}"),
                          )
                        ],
                      )),
                    );
                  }),
              height: double.infinity,
              color: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }
}
