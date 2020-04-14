import 'package:yrs_jdshop/services/Storage.dart';

class UserServices {
  static Future<Map<dynamic, dynamic>> get userInfo async {
    return await Storage.getMap("userinfo");
  }

  static Future<bool> get userInfoState async {
    Map map = await userInfo;
    return map?.isNotEmpty;
  }

  static romoveUserInfo() async {
    await Storage.remove("userinfo");
  }
}
