import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/model/ProductContentModel.dart';
import 'package:yrs_jdshop/pages/cart/CartNum.dart';
import 'package:yrs_jdshop/provider/Cart.dart';
import 'package:yrs_jdshop/services/CartegoryServices.dart';
import 'package:yrs_jdshop/services/EventBus.dart';
import 'package:yrs_jdshop/services/MyToast.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:yrs_jdshop/widget/JDButton.dart';

class ProductFirstPage extends StatefulWidget {
  final ProductContentitem productContentitem;

  const ProductFirstPage({Key key, this.productContentitem}) : super(key: key);
  @override
  _ProductFirstPageState createState() =>
      _ProductFirstPageState(productContentitem);
}

class _ProductFirstPageState extends State<ProductFirstPage>
    with AutomaticKeepAliveClientMixin {
  ProductContentitem _productContentitem;
  Map<String, String> _map = {};
  List<Attr> _attr = [];
  var _event;
  Cart cartProvider;

  _ProductFirstPageState(this._productContentitem);
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    this._event.cancel();
  }

  @override
  void initState() {
    super.initState();
    _attr = _productContentitem.attr;
    _attr.forEach((value) {
      _map["${value.cate}"] = value.list[0];
    });
    _event = eventBus.on<ProductContentEvent>().listen((event) {
      this._attrBottomSheet();
    });
  }

  _attrBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState1) {
            return GestureDetector(
              onTap: () {}, //防止点击自动收回
              child: Container(
                height: 400,
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    ListView(
                        children: _attr.map((attrItem) {
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "${attrItem.cate}:  ",
                              style: Theme.of(context).textTheme.subhead,
                            ),
                          ),
                          Container(
                            width: SceenUtils(context).setWidth(500),
                            child: Wrap(
                                spacing: 10,
                                children: attrItem.list.map((value) {
                                  return InkWell(
                                    onTap: () {
                                      setState1(() {
                                        setState(() {
                                          _map["${attrItem.cate}"] = value;
                                        });
                                      });
                                    },
                                    child: Chip(
                                        label: Text("$value"),
                                        backgroundColor:
                                            _map["${attrItem.cate}"] == value
                                                ? Colors.red
                                                : null),
                                  );
                                }).toList()),
                          )
                        ],
                      );
                    }).toList()
                          ..add(Wrap(
                            children: <Widget>[
                              Divider(),
                              Text("数量: "),
                              CartNum(_productContentitem),
                            ],
                          ))),
                    Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: SceenUtils(context).setHeight(88),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                child: JDButton(
                                  title: "加入购物车",
                                  color: Color.fromRGBO(253, 1, 0, 0.9),
                                  cellback: () async {
                                    _productContentitem.selectedAttr = _map;
                                    await CartegryServices.addCartData(
                                        this._productContentitem);
                                    await cartProvider.init();
                                    Navigator.of(context).pop();
                                    MyToast.showCenterShortToast("加入购物车");
                                  },
                                ),
                              ),
                              Expanded(
                                child: JDButton(
                                  title: "立即购买",
                                  color: Color.fromRGBO(255, 165, 0, 0.9),
                                  cellback: () {},
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<Cart>(context);

    return Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 12,
              child: Image.network(
                  "${Config.domain}${_productContentitem.pic.replaceAll("\\", "/")}",
                  fit: BoxFit.cover),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "${_productContentitem.title}",
                style: Theme.of(context).textTheme.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "${_productContentitem.subTitle}",
                style: Theme.of(context).textTheme.subhead,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text("特价: "),
                        Text("${_productContentitem.price}",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 30,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text("原价: "),
                        Text("${_productContentitem.oldPrice}",
                            style: TextStyle(
                                fontSize: 26,
                                decoration: TextDecoration.lineThrough))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                child: InkWell(
              onTap: () {
                _attrBottomSheet();
              },
              child: Row(
                children: <Widget>[
                  Text("已选: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${_map.values.join(",")}"),
                ],
              ),
            )),
            Divider(),
            Container(
                child: Row(
              children: <Widget>[
                Text("运费: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("免运费"),
              ],
            )),
            Divider(),
          ],
        ));
  }
}
