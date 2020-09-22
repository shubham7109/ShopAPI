import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final String GET_SUMMARY_URL = "http://localhost:8085/getSummary";
final String POST_PUT_ITEMS_URL = "http://localhost:8085/putItems";
final String RESET_URL = "http://localhost:8085/reset";
String serverMessages = "Initializing:";
Future<List<ShopItem>> itemList;
List<ShopItem> items;
int item1Count = 0;
int item2Count = 0;

Future<List<ShopItem>> getSummary() async {
  final response = await http.get(GET_SUMMARY_URL);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<ShopItem> itemList;
    var data = json.decode(response.body);
    itemList = data.map<ShopItem>((json) => ShopItem.fromJson(json)).toList();
    //print("Size: ${itemList.length}");
    return itemList;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    serverMessages += "Failed to get items";
    //throw Exception('Failed to get items');
  }
}

Future<http.Response> putItems() {
  return http.post(
    POST_PUT_ITEMS_URL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode([
      {"id": 1, "itemName": "Item 1", "itemStock": item1Count},
      {"id": 2, "itemName": "Item 2", "itemStock": item2Count}
    ]),
  );
}

Future<http.Response> resetDB() {
  return http.get(RESET_URL, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
}

class ShopItem {
  final int id;
  final String itemName;
  final int itemStock;

  ShopItem({this.id, this.itemName, this.itemStock});

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'],
      itemName: json['itemName'],
      itemStock: json['itemStock'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    itemList = getSummary();
  }

  updateText(String text) {
    setState(() {
      serverMessages += text + "\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop API - Cyr3con',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Shop API - Cyr3con'),
          ),
          body: Column(
            children: [
              SingleChildScrollView(
                child: FutureBuilder(
                  future: getSummary(),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? new ListItem(
                            snapshot.data,
                          )
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.green,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.check),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  putItems();
                                  item1Count = 0;
                                  item2Count = 0;
                                  itemList = getSummary();
                                });
                              },
                            ),
                          ),
                        ),
                        Text('Complete purchase')
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.orange,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.restore),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                resetDB();
                                item1Count = 0;
                                item2Count = 0;
                                itemList = getSummary();
                              });
                            },
                          ),
                        ),
                      ),
                      Text('Clear Database')
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 25, 50, 10),
                child: Text(
                  'Server Log Messages:',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Text(
                          '$serverMessages',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class ListItem extends StatefulWidget {
  List<ShopItem> shopItems;
  ListItem(List<ShopItem> shopItems) {
    this.shopItems = shopItems;
    items = shopItems;
  }
  @override
  _ListItemState createState() => new _ListItemState();
}

class _ListItemState extends State<ListItem> {
  updateServerText() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '${widget.shopItems[0].itemName}',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Units Available: ${widget.shopItems[0].itemStock}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Items to buy:',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: new IconButton(
                              icon: new Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (item1Count != 0) {
                                    item1Count--;
                                  }
                                });
                              },
                            ),
                          ),
                          new Text(item1Count.toString()),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: new IconButton(
                                icon: new Icon(Icons.add),
                                onPressed: () => setState(() => item1Count++)),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 25, 50, 25),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '${widget.shopItems[1].itemName}',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Units Available: ${widget.shopItems[1].itemStock}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Items to buy:',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: new IconButton(
                              icon: new Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (item2Count != 0) {
                                    item2Count--;
                                  }
                                });
                              },
                            ),
                          ),
                          new Text(item2Count.toString()),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: new IconButton(
                                icon: new Icon(Icons.add),
                                onPressed: () => setState(() => item2Count++)),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
