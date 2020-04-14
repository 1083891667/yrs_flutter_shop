import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SceenUtils {
  BuildContext context;

  SceenUtils(this.context) {
    init(context);
  }

  init(context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
  }

   setHeight(num height) {
    return ScreenUtil().setHeight(height);
  }

  setWidth(num width) {
    return ScreenUtil().setWidth(width);
  }


  static double get sceenWidth => ScreenUtil.screenWidth;
}
