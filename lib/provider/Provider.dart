import 'package:provider/provider.dart';
import 'package:yrs_jdshop/provider/Cart.dart';
import 'package:yrs_jdshop/provider/Counter.dart';

List<SingleChildCloneableWidget> providers = [
  ChangeNotifierProvider(create: (_) => Counter()),
  ChangeNotifierProvider(create: (_) => Cart()),
];
