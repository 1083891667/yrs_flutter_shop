import 'Storage.dart';

class SearchServices {
  static setHistoryData(keywords) async {
    List<String> list = await getHistoryList();
    if (!list.contains(keywords)) {
      list.insert(0, keywords);
      if (list.length > 8) {
        list.remove(list.last);
      }
    } else {
      list.remove(keywords);
      list.insert(0, keywords);
    }
    Storage.setList("searchList", list);
  }

  static Future<List<String>> getHistoryList() async {
    return await Storage.getList("searchList") ?? [];
  }

  static clearHistoryList() async {
    await Storage.remove('searchList');
  }

  static removeHistoryData(keywords) async {
    List list = await getHistoryList();
    list.remove(keywords);
    Storage.setList("searchList", list);
  }
}
