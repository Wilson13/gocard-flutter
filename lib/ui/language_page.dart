import 'package:flutter/material.dart';

import '../constants.dart';

class LanguagePage extends StatefulWidget {

  const LanguagePage();

  @override
  State<StatefulWidget> createState() => new _LanguagePageState();
  
  }
  
  class _LanguagePageState extends State<LanguagePage> {
   @override
    Widget build(BuildContext context) {
      return new Scaffold(
        body: makeBody()
      );
      
    }
  
    void showPersonalInfoPage() {
      Navigator.pushNamed(context, '/personal_info');
    }
  
    Widget makeBody() {
      return Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget> [
          // Title
          Center(
            child: 
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 80, right: 0, bottom: 0),
                child: Text(
                  "Queue Registration",
                  style: TextStyle(
                    color: BLACK_TEXT, 
                    fontFamily: 'Circular Std',
                    fontSize: 54,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400),
          ))),
          // Description
          Center(
            child: 
              Padding( 
                padding: const EdgeInsets.only(left: 0, top: 160, right: 0, bottom: 0),
                child: 
                  Text(
                  "Please choose a language",
                  style: TextStyle(
                    color: BLACK_TEXT, 
                    fontFamily: 'Source Sans Pro',
                    fontSize: 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal),
          ))),
          // Language buttons
          Center(
            child: 
              Padding( 
                padding: const EdgeInsets.only(left: 108, top: 61, right: 108, bottom: 0),
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      drawButton('English', BLUE_ENGLISH),
                      drawButton('中文', RED_MANDARIN),
                      drawButton('Bahasa Melayu', GREEN_MALAY),
                      drawButton('தமிழ்', ORANGE_TAMIL),
                  ])
          )),
          Expanded(
            child:
            Align(
            alignment: Alignment.bottomCenter,
            child: 
              Padding( 
                padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 45),
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Product of",
                        style: TextStyle(
                          color: BLACK_TEXT, 
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal),
                        ),
                        Image(
                          image: AssetImage('assets/ft_logo.jpeg'),
                          height: 60,)
                    ]
          )))),
        ]
      );
    }
  
    Widget drawButton(String btnText, Color btnColor){
      return SizedBox(
        width: 250,
        height: 250,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.transparent)
          ),
          onPressed: showPersonalInfoPage,
          color: btnColor,
          textColor: Colors.white,
          child: Text(
            btnText,
            style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 20)
          ),
      ));
    }
  }