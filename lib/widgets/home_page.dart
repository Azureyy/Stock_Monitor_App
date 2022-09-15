import 'package:flutter/material.dart';
import 'package:hw4/widgets/search.dart';
import 'package:hw4/widgets/favorites.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.MMMMd().format(now);
    TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Stock'),
          backgroundColor: (Colors.purple),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              hintText: "Search"),
                        ),
                        backgroundColor: (Colors.grey[850]),
                        actions: [
                        IconButton(
                          color:  Colors.grey[500],
                          onPressed: () => _controller.clear(),
                          icon: const Icon(Icons.clear),
                        )
                      ],
                      ),
                      body: const Center(
                        child: Text(
                          'No suggestions found!',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        
                      ),
                      
                    );
                  },
                ));
              },
            ),
          ],
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
                    const Divider(height: 60.0,  color: Colors.white, thickness: 1.5)
                  ]),
            ),
          ],
        ));
  }
}
