import 'package:flutter/material.dart';
import 'package:yrs_jdshop/pages/tabs/Cart.dart';
import 'package:yrs_jdshop/pages/tabs/Category.dart';
import 'package:yrs_jdshop/pages/tabs/User.dart';
import 'package:yrs_jdshop/pages/tabs/home.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 3; //
  PageController _pageController;
  List<Widget> tabs = [
    HomePage(),
    CartPage(),
    CategoryPage(),
    UserPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: this._currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: this.tabs,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: this._currentIndex,
          onTap: (index) {
            setState(() {
              this._currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          fixedColor: Colors.red,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("首页"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: Text("分类")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("购物车")),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text("我的")),
          ]),
    );
  }
}
