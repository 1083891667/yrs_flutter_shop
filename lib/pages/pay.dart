import 'package:flutter/material.dart';
import 'package:yrs_jdshop/services/ScreenUtiils.dart';
import 'package:yrs_jdshop/widget/JDButton.dart';

class PayPage extends StatefulWidget {
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  bool paytype = false; //微信

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("支付界面"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    paytype = true;
                  });
                },
                child: ListTile(
                  leading: Image.network(
                    "https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1208538952,1443328523&fm=26&gp=0.jpg",
                    fit: BoxFit.cover,
                    width: 60,
                  ),
                  title: Text("支付宝支付"),
                  trailing: paytype ? Icon(Icons.check) : null,
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  setState(() {
                    paytype = false;
                  });
                },
                child: ListTile(
                  leading: Image.network(
                    "https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3173584241,3533290860&fm=26&gp=0.jpg",
                    fit: BoxFit.cover,
                    width: 60,
                  ),
                  title: Text("微信支付"),
                  trailing: paytype ? null : Icon(Icons.check),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            width: SceenUtils(context).setWidth(750),
            child: JDButton(
              cellback: (){
                


              },
              color: Colors.red,
              title: "立即支付",
              hight: 50,
            ),
          )
        ],
      ),
    );
  }
}
