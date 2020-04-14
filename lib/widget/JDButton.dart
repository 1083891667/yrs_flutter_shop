import 'package:flutter/material.dart';

class JDButton extends StatelessWidget {
  final String title;
  final Color color;
  final Object cellback;
  final double hight;
  JDButton({this.title = "按钮", this.color = Colors.white, this.cellback,this.hight = 30});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: cellback,
      child: Container(
        height: hight,
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Text(
          "$title",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
