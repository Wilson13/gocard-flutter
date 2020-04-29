import 'package:flutter/material.dart';

class HomePageDiscarded extends StatefulWidget {

@override
  _HomePageState createState() => _HomePageState();

}

final makeBody = Center(
    child: new Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return makeCard;
        },
      ),
    )
  );

final makeCard = Card(
  elevation: 8.0,
  margin: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 24.0),
  child: Container(
    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    child: makeListTile,
  ),
);

final makeListTile = ListTile(
  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  leading: 
  CircleAvatar(
    backgroundColor: Colors.white,
    child: Text('1', style: TextStyle(fontSize: 22, color: Colors.black87))
  
  //Text("1", style: TextStyle(fontSize: 26),//color: Colors.white)),
  // leading: Container(
  //   padding: EdgeInsets.only(right: 12.0),
  //   decoration: new BoxDecoration(
  //       border: new Border(
  //           right: new BorderSide(width: 1.0, color: Colors.white24))),
  //   child: Text("1", style: TextStyle(fontSize: 26))//color: Colors.white)),
  ),
  title: Text(
    "S1234567B",
    // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

  subtitle: 
    Column(children: [
      Row(children:<Widget>[
        // Container(margin: const EdgeInsets.only(top: 10.0),
        // child: Icon(Icons.info_outline, color: Colors.yellowAccent)
        // ),
        Container(margin: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: Text("123_123_5")//, style: TextStyle(color: Colors.white))
        )
      ]),
      Row(children:<Widget>[
        // Container(margin: const EdgeInsets.only(top: 10.0),
        // child: Icon(Icons.subject, color: Colors.yellowAccent)
        // ),
        Container(margin: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: Text("Subject")//, style: TextStyle(color: Colors.white))
        )
      ])
    ])
  );
  // trailing:
  //     Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));

class ListPage extends StatefulWidget {
    ListPage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _HomePageState createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePageDiscarded> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: new AppBar(
          // iconTheme: new IconThemeData(color: Colors.black87),
          title: Center(
            child: new Text(
            "Cases", 
            // style: TextStyle(color: Colors.black87),
            ), 
        ),
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),//Theme.of(context).scaffoldBackgroundColor
        ),
        body: makeBody,
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
            ),
        ),
      );
    }
  }