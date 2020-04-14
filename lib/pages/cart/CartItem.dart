import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/pages/productContent/CartNum.dart';
import 'package:yrs_jdshop/provider/Cart.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';

class CartItem extends StatefulWidget {
  final cartItem;
  const CartItem(this.cartItem, {Key key}) : super(key: key);
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    Cart cartProvider = Provider.of<Cart>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
          width: 1,
          color: Colors.black12,
        )),
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: widget.cartItem["check"],
            onChanged: (value) {
              widget.cartItem["check"] = value;
              cartProvider.changeCartData();
            },
            activeColor: Colors.pink,
          ),
          Container(
              height: SceenUtils(context).setHeight(170),
              padding: EdgeInsets.all(5),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  "${Config.domain}${widget.cartItem["pic"].replaceAll("\\", "/")}",
                  fit: BoxFit.cover,
                ),
              )),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${widget.cartItem["title"]}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "类别: ${widget.cartItem["selectedAttr"].values.join(",")}")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${widget.cartItem["price"]}元",
                      style: TextStyle(color: Colors.red, fontSize: 22),
                    ),
                    CartNum(widget.cartItem),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
