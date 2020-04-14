import 'package:flutter/material.dart';
import 'package:yrs_jdshop/config/Config.dart';
import 'package:yrs_jdshop/model/ProductContentModel.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class ProductSecondPage extends StatefulWidget {
  final ProductContentitem productContentitem;

  const ProductSecondPage({Key key, this.productContentitem}) : super(key: key);
  @override
  _ProductSecondPageState createState() => _ProductSecondPageState();
}

class _ProductSecondPageState extends State<ProductSecondPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InAppWebView(
        initialUrl: "https://www.runoob.com/",
        onProgressChanged: (InAppWebViewController controller, int progress) {},
      ),
 
    );
  }
}
