import 'package:flutter/material.dart';
import 'package:yrs_jdshop/model/ProductContentModel.dart';

class ProductThirdPage extends StatefulWidget {
  final ProductContentitem productContentitem;

  const ProductThirdPage({Key key, this.productContentitem}) : super(key: key);
  @override
  _ProductThirdPageState createState() => _ProductThirdPageState();
}

class _ProductThirdPageState extends State<ProductThirdPage>  with AutomaticKeepAliveClientMixin {


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(itemBuilder: (context, index) {
        return Text("$index");
      }),
    );
  }
}
