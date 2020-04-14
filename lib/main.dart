import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yrs_jdshop/provider/Provider.dart';
import 'routers/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: MyRoutes.tabs,
          onGenerateRoute: onGenerateRoute,
          theme: ThemeData(primaryColor: Colors.white)),
    );
  }
}
