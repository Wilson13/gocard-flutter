// /// The base class for the different types of items the list can contain.
// abstract class ListItem {
//   /// The title line to show in a list item.
//   Widget buildTitle(BuildContext context);

//   /// The subtitle line, if any, to show in a list item.
//   Widget buildSubtitle(BuildContext context);

// }

// /// A ListItem that contains data to display a message.
// class CaseItem implements ListItem {
//   final String sender;
//   final String body;

//   MessageItem(this.sender, this.body);

//   Widget buildTitle(BuildContext context) => Text(sender);

//   Widget buildSubtitle(BuildContext context) => Text(body);
// }