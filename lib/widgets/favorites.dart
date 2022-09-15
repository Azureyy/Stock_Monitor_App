//import 'dart:html';

//import 'dart:html';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hw4/model/stock.dart';
import 'package:hw4/api/api.dart';
import 'package:hw4/widgets/favoriteList.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/src/material/search.dart';

class ResultPage extends StatelessWidget {
  String suggestion;
  ResultPage({required this.suggestion});
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.black,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.purple,
      ),
      textTheme: const TextTheme(
        headline6: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black54,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle:
            TextStyle(fontSize: 24.0, color: Color.fromRGBO(48, 48, 48, 1)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var stocks = context.watch<favList>().list;

    List<String> foundItems =
        stocks.where((item) => suggestion.contains(item)).toList();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Details'),
          actions: [
            IconButton(
              icon: Icon(
                (foundItems.isNotEmpty) ? Icons.star : Icons.star_border,
                size: 25,
              ),
              onPressed: () {
                if (!foundItems.isNotEmpty) {
                  context.read<favList>().add(suggestion);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          suggestion.substring(0, suggestion.indexOf('|') - 1) +
                              ' was added to watchlist')));
                } else {
                  context.read<favList>().delete(suggestion);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          suggestion.substring(0, suggestion.indexOf('|') - 1) +
                              ' was removed from watchlist')));
                }
              },
            )
          ],
          backgroundColor: Colors.grey[850],
        ),
        body: buildResults(context));
  }

  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.grey,
      ),
      onPressed: () {
        int count = 0;
        return Navigator.of(context).popUntil((_) => count++ >= 2);
      });

  @override
  Widget buildResults(BuildContext context) => FutureBuilder<Stock>(
        future: StockApi.getStock(stockSymbol: suggestion),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.purple)));
            default:
              if (snapshot.hasError || (snapshot.data?.change == null)) {
                return Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    'Failed to fetch stock data',
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                );
              } else {
                return buildResultSuccess(snapshot.data);
              }
          }
        },
      );

  @override
  Widget buildResultSuccess(Stock? stock) {
    // if (!foundItems.isNotEmpty) {
    //               context.read<favList>().add(suggestion);
    //             } else {
    //               context.read<favList>().delete(suggestion);
    //             }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      padding: EdgeInsets.all(5),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          RichText(
            text: TextSpan(
              text: stock!.stockSymbol + '\t\t\t',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
              children: [
                TextSpan(
                  text: stock.description,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          stock.change > 0
              ? RichText(
                  text: TextSpan(
                    text: stock.price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                    children: [
                      TextSpan(
                        text: '\t\t  +' + stock.change.toString(),
                        style: const TextStyle(
                          color: Color.fromRGBO(102, 187, 106, 1),
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                )
              : RichText(
                  text: TextSpan(
                    text: stock.price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    children: [
                      TextSpan(
                        text: '\t\t' + stock.change.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
          const SizedBox(height: 20),
          const Text(
            'Stats',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Open   ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      children: [
                        const TextSpan(
                          text: '\t\t',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: stock.open.toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'High     ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        children: [
                          const TextSpan(
                            text: '\t\t',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: stock.high.toString(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Low     ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      children: [
                        const TextSpan(
                          text: '\t\t',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: stock.low.toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Prev      ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        children: [
                          const TextSpan(
                            text: '\t\t',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: stock.prev.toString(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'About',
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text('Start date            ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  )),
              Text(stock.ipo.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  )),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Industry               ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  )),
              Text(stock.finnhubIndustry.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  )),
            ],
          ),
          Row(
            children: <Widget>[
              const Text('Website               ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  )),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: stock.weburl.toString(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        var url = stock.weburl.toString();
                        if (!await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
              ]))
            ],
          ),
          Row(
            children: <Widget>[
              Text('Exchange            ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  )),
              Text(stock.exchange.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  )),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Market cap         ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  )),
              Text(stock.market.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  void close(BuildContext context, String s) {}
}
