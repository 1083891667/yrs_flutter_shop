import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class ZhiboPage extends StatefulWidget {
  @override
  _ZhiboPageState createState() => _ZhiboPageState();
}

class _ZhiboPageState extends State<ZhiboPage> {
  // IjkMediaController controller = IjkMediaController();

  // @override
  // void initState() {
  //   super.initState();
  //   this.initMedia();
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  // //初始化视频
  // initMedia() async {
  //   await controller.setNetworkDataSource(
  //       'http://192.168.0.106:8000/live/zhibo',

  //       autoPlay: false);
  // }

  // Container(
  //   height: 200, //指定视频的高度
  //   child: IjkPlayer(
  //     mediaController: controller,
  //   ),
  // ),
  // SizedBox(height: 40),
  // Text('直播')
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("demo")),
      floatingActionButton: FlatButton(
          onPressed: () {
            list.add("");
            setState(() {});
          },
          child: Text("+")),
      body: Text("data")
    );
  }
}
