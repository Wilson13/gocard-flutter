

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perks_card/ui/payment_confirm_screen.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';


import '../constants.dart';
import '../helper.dart';

class PaymentSummaryScreen extends StatefulWidget {

  static const routeName = '/payment_summary';

  PaymentSummaryScreen();

  @override
  State<StatefulWidget> createState() => new _PaymentSummaryScreen();
}
  
class _PaymentSummaryScreen extends State<PaymentSummaryScreen>{
  
  ScrollController _scrollController;
  final Helper helper = new Helper();

  @override
  Widget build(BuildContext context) {
    _scrollController = new ScrollController();    
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      backgroundColor: BG_SUMMARY,
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
    
Widget drawAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: 
        Padding(
          padding: EdgeInsets.only(top: 36),
          child: Text(
            'Payment Summary',
            // 'Hey ' + 'Wilson' + '!',
            style: TextStyle(
              color: BLACK_TEXT, 
              fontFamily: 'SourceSansPro',
              fontSize: 20,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600
        )))
      );
  }

  Widget makeBody() {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        Stack(children: <Widget>[
          drawBackButton(),
          drawAppBar(),
        ],),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 26, 40, 0),
          child: drawSummary(),
        )
      ]);
  }
  
  Widget drawBackButton() {
    return Padding(
      padding: EdgeInsets.only(top: 28, left: 20),
      child:
        IconButton(
                // icon: Icon(Icons.notifications, color: BLACK_APP_TITLE),
                icon: Image(image: AssetImage('assets/images/back.png')),
                onPressed: () { Navigator.pop(context); },
              ),
      );   
  }

  Widget drawSummary() {
    return 
      Container(
        padding: EdgeInsets.only(top: 26),
        alignment: Alignment.topCenter,
        constraints: BoxConstraints(minWidth: 331, minHeight: 415),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text(
                'Total Bill',
                style: TextStyle(
                  color: PURPLE_TEXT, 
                  fontFamily: 'SourceSansPro',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal
                )
              )),
              Center(child: Text(
                '\$12.30',
                style: TextStyle(
                  color: BLACK_TEXT, 
                  fontFamily: 'SourceSansPro',
                  fontSize: 49,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w300
                )
              )),
            Padding(
              padding: EdgeInsets.only(top: 22),
              child: Divider(
                color: GREY_TEXT
            )),
            drawTexts('Merchant', 'McDonald\'s'),
            drawTexts('Location', 'Plaza Singapura'),
            drawTexts('Date & Time', '15 May 2020, 10:10am'),
            Padding(
              padding: EdgeInsets.only(top: 22),
              child: Divider(
                color: GREY_TEXT
            )),
            Padding(
              padding: EdgeInsets.only(left: 26, top: 26),
              child: Text(
              'PIN Number',
              style: TextStyle(
                color: PURPLE_TEXT, 
                fontFamily: 'SourceSansPro',
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w300
              )
            )),
            Padding(
              padding: EdgeInsets.only(top: 24, bottom: 34),
              child:
              PinEntryTextField(
                showFieldAsBox: false,
                fields: 6,
                onSubmit: (String pin){
                  Navigator.pushReplacementNamed(context, PaymentConfirmScreen.routeName);
                }),
            )
          ],)
      );
  }

  Widget drawTexts(String label, String content) {
    return 
      Padding(
        padding: EdgeInsets.only(top: 28, left: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
              label,
              style: TextStyle(
                color: GREY_LIGHT_TEXT, 
                fontFamily: 'SourceSansPro',
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal
              )
            )),
            Expanded(
              flex: 2,
              child: Text(
              content,
              style: TextStyle(
                color: BLACK_TEXT, 
                fontFamily: 'SourceSansPro',
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal
              )
            )),
          ],
        )
    );
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

  
