
import 'package:yrs_jdshop/model/ProductContentModel.dart';
import 'package:yrs_jdshop/services/Storage.dart';

class CartegryServices {
  static addCartData(ProductContentitem pro) async {
    Map cartMap;
    cartMap = await Storage.getMap("777");
    if (cartMap.containsKey("${pro.sId}")) {
      cartMap["${pro.sId}"]["count"] += pro.count;
      cartMap["${pro.sId}"]["selectedAttr"] = pro.selectedAttr;
      cartMap["${pro.sId}"]["check"] = pro.check;
    } else {
      cartMap["${pro.sId}"] = toJson(pro);
    }
    await Storage.setMap("777", cartMap);
  }

  static Map<String, dynamic> toJson(ProductContentitem pro) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = pro.sId;
    data['title'] = pro.title;
    data['price'] = pro.price;
    data['pic'] = pro.pic;
    data['count'] = pro.count;
    data['selectedAttr'] = pro.selectedAttr;
    data['check'] = pro.check;
    return data;
  }
}
