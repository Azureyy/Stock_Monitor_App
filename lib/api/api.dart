import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:hw4/model/stock.dart';

class StockApi {
  static const apiKey = 'c9jm6e2ad3idg7p5e7p0';

  static Future<List<String>> searchStocks({@required String? query}) async {
    final response = await http.get(
        Uri.parse('https://finnhub.io/api/v1/search?q=$query&token=$apiKey'));

    final body = json.decode(response.body)['result'];

    return body.map<String>((json) {
      final stockDescrip = json['description'];
      final stockSymbol = json['symbol'];
      final ret = stockSymbol + ' | ' + stockDescrip;

      return '$ret';
    }).toList();
  }

  static Future<Stock> getStock({@required String? stockSymbol}) async {
    final pos = (stockSymbol!.indexOf('|'));
    String result = stockSymbol.substring(0, pos - 1);

    final url1 =
        'https://finnhub.io/api/v1/stock/profile2?symbol=$result&token=$apiKey';
    final url2 = 'https://finnhub.io/api/v1/quote?symbol=$result&token=$apiKey';
    final response1 = await http.get(Uri.parse(url1));
    final body1 = json.decode(response1.body);
    final response2 = await http.get(Uri.parse(url2));
    final body2 = json.decode(response2.body);

    return Stock(
        price: body2['c'].toString(),
        change: body2['d'],
        high: body2['h'].toString(),
        open: body2['o'].toString(),
        low: body2['l'].toString(),
        prev: body2['pc'].toString(),
        stockSymbol: body1['ticker'].toString(),
        description: body1['name'].toString(),
        exchange: body1['exchange'].toString(),
        ipo: body1['ipo'].toString(),
        finnhubIndustry: body1['finnhubIndustry'].toString(),
        weburl: body1['weburl'].toString(),
        market: body1['marketCapitalization'].toString());
  }
}
