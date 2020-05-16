

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../constants.dart';
import '../helper.dart';
import 'payment_summary_screen.dart';

class QRScreen extends StatefulWidget {

  static const routeName = '/qr';

  QRScreen();

  @override
  State<StatefulWidget> createState() => new _QRScreen();
}
  
class _QRScreen extends State<QRScreen>{

  
  ScrollController _scrollController;
  final Helper helper = new Helper();

  @override
  Widget build(BuildContext context) {
      
    _scrollController = new ScrollController();    
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body:
        SingleChildScrollView(
          controller: _scrollController,
          reverse: true,
            child: new GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                }, 
              child: makeBody()
              )
        ),
      );
  }

  _onLayoutDone(_){
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    super.initState();
  }
    
  Widget makeBody() {
    return
      Stack(children: <Widget>[
        InkWell(
          child: Image(image: AssetImage('assets/images/qr_page.png')),
          onTap: () { Navigator.pushNamed(context, PaymentSummaryScreen.routeName); }
        ),
        drawBackButton(),
      ],);
  }
  
  Widget drawBackButton() {
    return Padding(
      padding: EdgeInsets.only(top: 33, left: 20),
      child:
        Container(
          // constraints: BoxConstraints(minWidth: 50, minHeight: 50),
          decoration: new BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(4, 8), // changes position of shadow
            )],
            shape: BoxShape.circle,
            color: Colors.white),
            child: IconButton(
                // icon: Icon(Icons.notifications, color: BLACK_APP_TITLE),
                icon: Image(image: AssetImage('assets/images/back.png')),
                onPressed: () { Navigator.pop(context); },
              ),
      ));   
  }

  Widget drawBottomNavigation() {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: 
        Container(
          // constraints: BoxConstraints(minWidth: 355, minHeight: 210),
          padding: EdgeInsets.fromLTRB(58, 0, 58, 0),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)),
            color: BG_BTM_NAV),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                // icon: Icon(Icons.notifications, color: Colors.white),
                icon: Image(image: AssetImage('assets/images/home.png')),
                onPressed: () {  },
              ),
              IconButton(
                // icon: Icon(Icons.notifications, color: Colors.white),
                icon: Image(image: AssetImage('assets/images/location.png')),
                onPressed: () {  },
              ),
              IconButton(
                // icon: Icon(Icons.notifications, color: Colors.white),
                icon: Image(image: AssetImage('assets/images/coupons.png')),
                onPressed: () {  },
              ),
              IconButton(
                // icon: Icon(Icons.notifications, color: Colors.white),
                icon: Image(image: AssetImage('assets/images/account.png')),
                onPressed: () {  },
              ),
            ])
      ));
  }

  void showToast(String message) {
    if (!(["", null, false, 0].contains(message))) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
    );
  }
 }

  void navigateToRoot() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}

  
