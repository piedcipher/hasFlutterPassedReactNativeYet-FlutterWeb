import 'package:flutter_web/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Has Flutter Passed React Native Yet',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  bool _hasIt = true;
  int _flutterStargazersCount, _reactnativeStargazersCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Has Flutter Passed React Native Yet?",
                      style: TextStyle(fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _hasIt ? "Yes" : "Not Yet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 70),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        initialData: "Loading...",
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              _hasIt
                                  ? "Ahead by ${snapshot.data} stars!"
                                  : "Only stars ${snapshot.data} away!",
                              style: TextStyle(fontSize: 17),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        initialData: "Loading...",
                        future: getData(),
                        builder: (context, snapshot) {
                          return IntrinsicWidth(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(right: 8),
                                            child: FlutterLogo()),
                                        Text(
                                          _flutterStargazersCount.toString(),
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: Text(
                                      _reactnativeStargazersCount.toString(),
                                      style: TextStyle(fontSize: 20),
                                    ))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getData() async {
    _flutterStargazersCount = await getStargazersCount(
        "https://api.github.com/repos/flutter/flutter");
    _reactnativeStargazersCount = await getStargazersCount(
        "https://api.github.com/repos/facebook/react-native");
    return (_flutterStargazersCount - _reactnativeStargazersCount).abs();
  }

  Future getStargazersCount(String apiUrl) async {
    var response = await http.get(apiUrl);
    var json = jsonDecode(response.body);
    return json['stargazers_count'];
  }
}
