

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perks_card/ui/qr_screen.dart';


import '../constants.dart';
import '../helper.dart';

class MapScreen extends StatefulWidget {

  static const routeName = '/map';

  MapScreen();

  @override
  State<StatefulWidget> createState() => new _MapScreen();
}
  
class _MapScreen extends State<MapScreen>{

  
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
        bottomNavigationBar: drawBottomNavigation(),
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
          child: Image(image: AssetImage('assets/images/map.png')),
          onTap: () { showPopup(); }
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
            boxShadow: [ BoxShadow(
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

  void showPopup() {
    showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return SafeArea(
        child: Builder(builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              //  width: 150.0,
              //  height: 150.0,
              child: drawMapAndButton()
          ));
        }),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context)
        .modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration:
        const Duration(milliseconds: 150));
  }

  Widget drawMapAndButton() {
    return Stack(children: <Widget>[
      Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(
            Radius.circular(10.0) 
            ),
          color: Colors.white),
          child:Image(image: AssetImage('assets/images/popup.png'))
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: drawPayButton()
      )
    ]);
  }

  Widget drawPayButton() {
    return Container(constraints: BoxConstraints(maxWidth: 205),
    padding: EdgeInsets.only(bottom: 40),
    child:
        RaisedButton(
          shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0)),
          color: PURPLE_BUTTON,
          child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Tab(icon: new Image.asset("assets/images/pay.png"), text: null),
              SizedBox(width: 14),
              Text(
                'Pay Now',
                style: TextStyle(
                  color: Colors.white, 
                  fontFamily: 'SourceSansPro',
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600
                )
              ),
            ],),
          onPressed: () { Navigator.pushNamed(context, QRScreen.routeName); },
        )
      );
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

  
