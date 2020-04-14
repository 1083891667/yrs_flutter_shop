import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yrs_jdshop/routers/Router.dart';
import 'package:yrs_jdshop/services/SearchServices.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController;
  List<String> _histroySearch = [];

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    _getHistroySearch();
  }

  _getHistroySearch() async {
    List<String> histroySearch = await SearchServices.getHistoryList();
    setState(() {
      _histroySearch = histroySearch.isEmpty ? ["无搜索记录"] : histroySearch;
    });
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, size: 28, color: Colors.black87),
              onPressed: () {
                SearchServices.setHistoryData(textEditingController.text);
                Navigator.pushReplacementNamed(context, MyRoutes.productList,
                    arguments: {"keyWrods": textEditingController.text});
              })
        ],
        title: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                controller: textEditingController,
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                        gapPadding: 0)),
              ))
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                child: Text(
              "热搜",
              style: Theme.of(context).textTheme.title,
            )),
            Divider(),
            Wrap(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.8),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("女装2435653")),
                Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.8),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("女装2435653")),
              ],
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "历史记录",
                  style: Theme.of(context).textTheme.title,
                ),
                OutlineButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.delete),
                      Text("清空历史"),
                    ],
                  ),
                  onPressed: () async {
                    await SearchServices.clearHistoryList();
                    _getHistroySearch();
                  },
                )
              ],
            )),
            Divider(),
            Column(
                children: _histroySearch.map((v) {
              return InkWell(
                onLongPress: () async {
                  await SearchServices.removeHistoryData(v);
                  _getHistroySearch();
                },
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text("$v"),
                    ),
                    Divider(),
                  ],
                ),
              );
            }).toList())
          ],
        ),
      ),
    );
  }
}
