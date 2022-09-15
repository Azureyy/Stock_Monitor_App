import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Stock {
  final String stockSymbol;
  final String price;
  final double change;
  final String open;
  final String high;
  final String low;
  final String prev;
  final String description;
  final String ipo;
  final String finnhubIndustry;
  final String weburl;
  final String exchange;
  final String market;

  const Stock(
      {required this.price,
      required this.change,
      required this.open,
      required this.high,
      required this.low,
      required this.prev,
      required this.stockSymbol,
      required this.description,
      required this.exchange,
      required this.ipo,
      required this.finnhubIndustry,
      required this.weburl,
      required this.market});
}
