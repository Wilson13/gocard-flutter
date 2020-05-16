

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perks_card/bloc/payment_bloc.dart';
import 'package:perks_card/ui/home_screen.dart';
import 'package:provider/provider.dart';


import '../constants.dart';
import '../helper.dart';

class PaymentConfirmScreen extends StatefulWidget {

  static const routeName = '/payment_confirm';

  PaymentConfirmScreen();

  @override
  State<StatefulWidget> createState() => new _PaymentConfirmScreen();
}
  
class _PaymentConfirmScreen extends State<PaymentConfirmScreen>{
  
  ScrollController _scrollController;
  final Helper helper = new Helper();

  @override
  Widget build(BuildContext context) {
    _scrollController = new ScrollController();    
    return new Scaffold(
      resizeToAvoidBottomInset: false,
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
            'Payment Successful',
            // 'Hey ' + 'Wilson' + '!',
            style: TextStyle(
              color: GREEN_LIGHT_TEXT, 
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
          padding: EdgeInsets.fromLTRB(40, 26, 40, 20),
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
        constraints: BoxConstraints(minWidth: 331),
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
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 18),
              child: Text(
              'Dining',
              style: TextStyle(
                color: BLACK_TEXT, 
                fontFamily: 'SourceSansPro',
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600
            ))),
            drawLevel(),
            drawRewards(),
            drawTickText('10% Cashback'),
            drawTickText('\$2 Off Gift Vouchers'),
            drawTickText('+35 Experience'),
            drawPayButton(),
          ],)
      );
  }

  Widget drawLevel() {
    return 
      Container(padding: EdgeInsets.only(left: 36, right: 36, top: 26),
        child: 
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            Flexible(
              flex: 1, 
              child: Image(image: AssetImage('assets/images/diner.png'))
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 2, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text(
                  'Level 6',
                  style: TextStyle(
                    color: BLACK_TEXT, 
                    fontFamily: 'SourceSansPro',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal
                )),
              SizedBox(height: 10),
              Image(image: AssetImage('assets/images/exp_bar.png')),
              SizedBox(height: 22),
              Text(
                'Experience',
                style: TextStyle(
                  color: BLACK_TEXT, 
                  fontFamily: 'SourceSansPro',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal
              )),
              SizedBox(height: 10),
              Image(image: AssetImage('assets/images/lvl_bar.png'))
            ])),
        ],
      )
    );
  }

  Widget drawRewards() {
    return Padding(
      padding: EdgeInsets.only(left: 32, top: 36),
      child: Text(
              'REWARDS',
              style: TextStyle(
                color: GREY_TEXT, 
                fontFamily: 'SourceSansPro',
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal
              )),
    );
  }

  Widget drawTickText(String content) {
    return 
      Padding(
        padding: EdgeInsets.only(top: 20, left: 28, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(image: AssetImage('assets/images/tick.png')
            ),
            SizedBox(width: 28),
            Text(
              content,
              style: TextStyle(
                color: BLACK_TEXT, 
                fontFamily: 'SourceSansPro',
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal
              )
            ),
          ],
        )
    );
  }

  Widget drawPayButton() {
    return 
      Consumer<PaymentBloc>(builder: (context, bloc, child) {
        return 
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child:
              RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0)),
                  color: PURPLE_BUTTON,
                  child: 
                    Container(padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    alignment: Alignment.center,
                      child:
                        Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white, 
                            fontFamily: 'SourceSansPro',
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600
                          )
                        )
                    ),
                  onPressed: () async { 
                    try{
                      await bloc.makePayment("12.3");
                      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                    } catch(err) {
                      if (err != null)
                        showToast(err.toString());
                      else 
                        showToast("Payment unsuccessful, please try again later.");
                    }
                    },
                )
          );
    });
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

  
