

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perks_card/bloc/home_bloc.dart';
import 'package:perks_card/ui/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../helper.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {

  static const routeName = '/home';

  HomeScreen();

  @override
  State<StatefulWidget> createState() => new _HomeScreen();
}
  
class _HomeScreen extends State<HomeScreen>{

  String _username;

  // final String token;
  final RegExp postalExp = new RegExp(
    r"^\d{6}$",
    caseSensitive: false,
    multiLine: false,
  );

  ScrollController _scrollController;
  final Helper helper = new Helper();

  String selectedValue;

  @override
  Widget build(BuildContext context) {
      
    // Extract the arguments from the current ModalRoute settings and cast
    // them as UserData.
    // final Map<String, Object> receivedData = ModalRoute.of(context).settings.arguments;
    // _caseData = receivedData["caseData"];
    // _userData = receivedData["userData"];
    // _photoModel = receivedData["photoModel"];
    _scrollController = new ScrollController();

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body:
        SingleChildScrollView(
          controller: _scrollController,
          reverse: false,
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

  // _onLayoutDone(_){
  //   _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  // }

  _getUserName() async {
    _username = await helper.getUsername(); 
  }

  Future<String> _getCABalance() async {
    try {
      return await Provider.of<HomeBloc>(context, listen: true).getCABalance();
    } catch (err) {
      showToast(err.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    _getUserName();
  }
    
  Widget makeBody() {
    return
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            // Header
            drawAppBar(),
            drawCreditCard(),
            drawCategories(),
            drawFirstRowCharacters(),
            drawSecondRowCharacters(),
            SizedBox(height: 30,)
            // helper.headers(Headers.SUMMARY, navigateToRoot),
            // Summary 
            // summary(),
          ]
    );
  }
  
  Widget drawAppBar() {
    String username = _username == null ? "user" : _username;
    return Padding(
      padding: EdgeInsets.only(left: 32, top: 40),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Hey ' + username + '!',
              // 'Hey ' + 'Wilson' + '!',
              style: TextStyle(
                color: BLACK_TEXT, 
                fontFamily: 'SourceSansPro',
                fontSize: 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600
              )),
            Row(children: <Widget>[
              IconButton(
                // icon: Icon(Icons.notifications, color: BLACK_APP_TITLE),
                icon: Image(image: AssetImage('assets/images/bell.png')),
                onPressed: () {  },
              ),
              IconButton(
                // icon: Icon(Icons.power_settings_new, color: BLACK_APP_TITLE),
                icon: Image(image: AssetImage('assets/images/power.png')),
                onPressed: () { Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false); },
              ),
            ],)
          ]
    ));
  }

  Widget drawCreditCard() {
    final currencyFormat = new NumberFormat.currency(locale: "en_SG", symbol: "S\$", decimalDigits: 2);
    return Consumer<HomeBloc>(builder: (context, homeBloc, child) {
      return FutureBuilder(
        future: _getCABalance(),
        builder: (BuildContext contect, AsyncSnapshot<String> snapshot) {
          String balance = snapshot.hasData ? currencyFormat.format(double.parse(snapshot.data)) : "\$123.00";
          return Padding(
            padding: EdgeInsets.fromLTRB(28, 36, 28, 0),
            child: 
              Container(
                constraints: BoxConstraints(minWidth: 355, minHeight: 210),
                padding: EdgeInsets.fromLTRB(28, 32, 28, 32),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [ BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: Offset(0, 8), // changes position of shadow
                  )],
                  gradient: new LinearGradient( 
                    begin: Alignment(-0.9, 2.0),
                    end: Alignment(1.0, 1.0),
                    colors: [
                      Color(0xFFBF99F1),
                      Color(0xFF6CBFF2),
                      Color(0XFFB5F1F2),
                      // Color(0xFF313DA8),
                      // Color(0xFF212B8A),
                    ])),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          // 'Hey ' + _username + '!',
                          'Wilson',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SourceSansPro',
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal
                        )),
                        IconButton(
                          // icon: Icon(Icons.notifications, color: Colors.white),
                          icon: Image(image: AssetImage('assets/images/paywave.png')),
                          onPressed: () {  },
                        ),
                    ]
                  ),
                  Text(
                    // 'Hey ' + _username + '!',
                    // '\$12,345.00',
                    balance,
                    style: TextStyle(
                      color: Colors.white, 
                      fontFamily: 'SourceSansPro',
                      fontSize: 36,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300
                    )),
                ],)
            ));
        });
    });
  }

  Widget drawCategories() {
    return Padding(
      padding: EdgeInsets.only(left: 32, top: 36),
      child: Text(
              // 'Hey ' + _username + '!',
              'CATEGORIES',
              style: TextStyle(
                color: GREY_TEXT, 
                fontFamily: 'SourceSansPro',
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal
              )),
    );
  }

  Widget drawFirstRowCharacters() {
    return Padding(
      padding: EdgeInsets.only(left: 28, top: 18, right: 28),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            drawCharacter('Dining', 'assets/images/diner.png', 'Level 6', 'Exp 15/50', BG_DINING),
            SizedBox(width: 8),
            drawCharacter('Shopping', 'assets/images/shopper.png', 'Level 6', 'Exp 15/50', BG_SHOPPING),
            SizedBox(width: 8),
            drawCharacter('Travel', 'assets/images/daily.png', 'Level 6', 'Exp 15/50', BG_TRAVEL),
          ]
    ));
  }

  Widget drawSecondRowCharacters() {
    return Padding(
      padding: EdgeInsets.only(left: 28, top: 18, right: 28),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            drawCharacter('Daily Expense', 'assets/images/daily.png', 'Level 6', 'Exp 15/50', BG_DAILY),
            SizedBox(width: 8),
            drawCharacter('Big Tickets', 'assets/images/big_ticket.png', 'Level 6', 'Exp 15/50', BG_BIG_TICKETS),
            SizedBox(width: 8),
            drawCharacter('Airport Lounge', 'assets/images/lounge.png', 'Level 6', 'Exp 15/50', BG_AIRPORT),
          ]
    ));
  }
  
  Widget drawCharacter(String text, String imageName, String level, String exp, Color color) {
    return 
      Expanded(child: 
        InkWell(
          onTap: () { Navigator.pushNamed(context, MapScreen.routeName); },
          child: 
        Container(
          padding: EdgeInsets.only(top: 11),
          decoration: new BoxDecoration(
            boxShadow: [ BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(4, 8), // changes position of shadow
            )],
            borderRadius: BorderRadius.circular(20),
            color: color),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(maxHeight: 80),
                  child: Image(image: AssetImage(imageName))
                  ),
                Padding(padding: EdgeInsets.only(top: 6, left: 13),
                  child:
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white, 
                        fontFamily: 'SourceSansPro',
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600
                    )
                )),
                Padding(padding: EdgeInsets.only(left: 13),
                  child: Text(
                    level,
                    style: TextStyle(
                      color: Colors.white, 
                      fontFamily: 'SourceSansPro',
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal
                ))),
                Padding(padding: EdgeInsets.only(left: 13, bottom: 13),
                  child: Text(
                    exp,
                    style: TextStyle(
                      color: Colors.white, 
                      fontFamily: 'SourceSansPro',
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal
                ))),
              ]
      ))));   
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

  
