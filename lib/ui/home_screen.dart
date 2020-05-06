import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

final List<ListItem> items;

  const HomeScreen({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Center(
          child: new Text(
          "Cases", 
          style: TextStyle(color: Colors.black87),
          ), 
      ),
      elevation: 0.1,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor
      ),
      body: makeBody(items)
    );
  }
}

Widget makeBody(List<ListItem> items) {
  return ListView.builder(
    // Let the ListView know how many items it needs to build.
    itemCount: items.length,
    // Provide a builder function. This is where the magic happens.
    // Convert each item into a widget based on the type of item it is.
    itemBuilder: (context, index) {
      final item = items[index];

      return ListTile(
        title: item.buildTitle(context),
        subtitle: item.buildSubtitle(context),
      );
    },
  );
}

final makeCard = Card(
  elevation: 8.0,
  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  child: Container(
    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    child: makeListTile,
  ),
);

final makeListTile = ListTile(
  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  leading: Container(
    padding: EdgeInsets.only(right: 12.0),
    decoration: new BoxDecoration(
        border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.white24))),
    child: Text("1", style: TextStyle(color: Colors.white)),
  ),
  title: Text(
    "S1234567B",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

  subtitle: 
    Column(children: [
      Row(children:<Widget>[
        Icon(Icons.confirmation_number, color: Colors.yellowAccent),
        Text("123_123_5", style: TextStyle(color: Colors.white))
      ]),
      Row(children:<Widget>[
        Icon(Icons.confirmation_number, color: Colors.yellowAccent),
        Text("123_123_5", style: TextStyle(color: Colors.white))
      ])
    ])
  );
  // trailing:
  //     Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) => Text(sender);

  Widget buildSubtitle(BuildContext context) => Text(body);
}