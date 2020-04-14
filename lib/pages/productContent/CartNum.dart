import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yrs_jdshop/model/ProductContentModel.dart';
import 'package:yrs_jdshop/provider/Cart.dart';
import 'package:yrs_jdshop/services/CartegoryServices.dart';

class CartNum extends StatefulWidget {
  final cartItem;

  const CartNum(this.cartItem, {Key key}) : super(key: key);
  @override
  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  @override
  Widget build(BuildContext context) {
    Cart cartProvider = Provider.of<Cart>(context);

    Widget _btn(String s, Object cb) {
      return AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          onTap: cb,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              width: 1,
              color: Colors.black12,
            )),
            child: Text("$s"),
          ),
        ),
      );
    }

    return Container(
      height: 25,
      width: 80,
      child: Row(
        children: <Widget>[
          _btn("-", () {
            if (widget.cartItem["count"] > 1) {
              widget.cartItem["count"]--;
              widget.cartItem["check"] = true;
              cartProvider.changeCartData();
            }
          }),
          Container(
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.black12,
              ),
              top: BorderSide(
                width: 1,
                color: Colors.black12,
              ),
            )),
            child: Text("${widget.cartItem["count"]}"),
          ),
          _btn("+", () {
            widget.cartItem["count"]++;
            widget.cartItem["check"] = true;
            cartProvider.changeCartData();
          })
        ],
      ),
    );
  }
}
