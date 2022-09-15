import 'package:flutter/material.dart';
import 'package:hw4/api/api.dart';
import 'package:hw4/model/stock.dart';
import 'package:hw4/widgets/favorites.dart';
import 'package:intl/intl.dart';
import 'package:hw4/widgets/favoriteList.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

void main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Encode and store data in SharedPreferences
  // final String encodedData = Stock.encode([
  //   Stock(id: 1, ...),
  //   Stock(id: 2, ...),
  // ]);

  // await prefs.setString('stock_key', encodedData);

  // // Fetch and decode data
  // final String musicsString = await prefs.getString('musics_key');

  // final List<Stock> musics = Stock.decode(musicsString);
  runApp(ChangeNotifierProvider<favList>(
    child: const MyApp(),
    create: (_) => favList(), // Create a new ChangeNotifier object
  ));
}

class searchPage extends StatefulWidget {
  @override
  createState() => new _searchPage();
}

class _searchPage extends State<searchPage> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.MMMMd().format(now);
    TextEditingController _controller = TextEditingController();
    var stocks = context.watch<favList>().list;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Stock'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                showSearch(
                  context: context,
                  delegate: StockSearch(),
                );
              },
            )
          ],
          backgroundColor: Colors.purple,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "STOCK WATCH",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        )),
                    Align(
                        alignment: Alignment.topRight,
                        child: Text(formattedDate,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right)),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Favorites",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.left)),
                    const Divider(
                        height: 50.0, color: Colors.white, thickness: 2),
                    //if (!stocks.isNotEmpty)
                    stocks.isEmpty
                        ? const Text("Empty",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left)
                        : ListView.separated(
                            shrinkWrap: true,
                            //padding: const EdgeInsets.all(8),
                            itemCount: stocks.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = stocks[index];
                              return Dismissible(
                                  key: UniqueKey(),
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: const Text(
                                                  "Delete Confirmation"),
                                              content: const Text(
                                                  "Are you sure you want to delete this item?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child:
                                                        const Text("Delete")),
                                                FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text("Cancel"),
                                                ),
                                              ]);
                                        });
                                  },
                                  onDismissed: (direction) {
                                    // Remove the item from the data source.
                                    setState(() {
                                      stocks.removeAt(index);
                                    });

                                    // Then show a snackbar.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(item.substring(
                                                    0, item.indexOf('|') - 1) +
                                                ' was removed from watchlist')));
                                  },
                                  background: Container(
                                      alignment: Alignment.centerRight,
                                      color: Colors.red,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      )),
                                  child: Container(
                                    height: 50,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ResultPage(
                                                    suggestion: stocks[index],
                                                  )),
                                        );
                                      },
                                      child: Text(
                                        '\t\t\t\t\t\t' +
                                            stocks[index].substring(
                                                0,
                                                stocks[index].indexOf('|') -
                                                    1) +
                                            '\n\t\t\t\t\t\t' +
                                            stocks[index].substring(
                                                stocks[index].indexOf('|') + 2,
                                                stocks[index].indexOf('|') +
                                                    3) +
                                            stocks[index]
                                                .substring(
                                                    stocks[index].indexOf('|') +
                                                        3)
                                                .toLowerCase(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                                        height: 60.0,
                                        color: Colors.white,
                                        thickness: 2),
                          ),
                  ]),
            ),
          ],
        ));
  }
}

class StockSearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.purple,
      ),
      textTheme: const TextTheme(
        headline6: TextStyle(fontSize: 20.0, color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(48, 48, 48, 1),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.grey,
          ),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => FutureBuilder<Stock>(
        future: StockApi.getStock(stockSymbol: query),
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
              return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text(
                  'Fail to fetch stock data',
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
              );
          }
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        color: Colors.black,
        child: FutureBuilder<List<String>>(
          future: StockApi.searchStocks(query: query),
          builder: (context, snapshot) {
            if (query.isEmpty) return buildNoSuggestions();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.purple)));
              default:
                if (snapshot.hasError || !snapshot.hasData) {
                  return buildNoSuggestions();
                } else {
                  return buildSuggestionsSuccess(snapshot.data!);
                }
            }
          },
        ),
      );

  Widget buildNoSuggestions() => const Center(
        child: Text(
          'No suggestions found!',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      );

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ResultPage(
                    suggestion: suggestion,
                  ),
                ),
              );
            },
            title: RichText(
              text: TextSpan(
                text: suggestion,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      );
}
