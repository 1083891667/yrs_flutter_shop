import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/model/ProductContentModel.dart';

class CartNum extends StatefulWidget {
  final ProductContentitem productContentitem;

  const CartNum(this.productContentitem, {Key key}) : super(key: key);
  @override
  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  @override
  Widget build(BuildContext context) {
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
            setState(() {
              if (widget.productContentitem.count > 1) {
                widget.productContentitem.count--;
              }
            });
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
            child: Text("${widget.productContentitem.count}"),
          ),
          _btn("+", () {
            setState(() {
              widget.productContentitem.count++;
            });
          })
        ],
      ),
    );
  }
}
