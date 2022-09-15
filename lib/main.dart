import 'package:flutter/material.dart';
import 'package:hw4/widgets/home_page.dart';
import 'package:hw4/widgets/search.dart';
import 'package:intl/intl.dart';
import 'package:hw4/widgets/search.dart';
import 'package:hw4/api/api.dart';
import 'package:flutter/material.dart';
import 'package:hw4/model/stock.dart';
import 'package:hw4/widgets/favorites.dart';
import 'package:intl/intl.dart';
import 'package:hw4/widgets/favoriteList.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
// @dart=2.9

void main() => runApp(ChangeNotifierProvider<favList>(
      child: const MyApp(),
      create: (_) => favList(), // Create a new ChangeNotifier object
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: _title,
        home: searchPage());
  }
}
