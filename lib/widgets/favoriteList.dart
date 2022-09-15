import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hw4/model/stock.dart';
import 'package:hw4/api/api.dart';

class favList with ChangeNotifier {
  List<String> _favList = [];
  int get count => _favList.length;
  List<String> get list => _favList;

  void add(String s) {
    _favList.add(s);
    notifyListeners();
  }

  void delete(String s) {
    _favList.remove(s);
    notifyListeners();
  }
}
