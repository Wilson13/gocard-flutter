

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'constants.dart' as Constants;
import 'constants.dart';

enum Headers {PERSONAL_INFO, ADDRESS, PHOTO, SUBJECT, SUMMARY}

class Helper {

  Future<String> getAuthToken() async {
    final storage = new FlutterSecureStorage();

    // Read value 
    return null;
    // return await storage.read(key: Constants.AUTH_KEY);
    
  }

  Future<void> setAuthToken(String value) async {
    final storage = new FlutterSecureStorage();

    // Read value 
    return await storage.write(key: Constants.AUTH_KEY, value: value);
  }

  void displayToast(String message) {
    if (!(["", null, false, 0].contains(message))) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void userUnauthenticated(context) {
    // Remove all routes and redirect user to root page
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  BoxDecoration dateBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: BLUE_INPUT_BORDER,
        width: 1.0
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) 
      ),
    );
  }

  OutlineInputBorder textFieldDecoration() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: BLUE_INPUT_BORDER, width: 1),
    );
  } 

  BoxDecoration summaryBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Constants.PURPLE_SUMMARY_BACKGROUND,
        width: 1.0
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(20.0) 
      ),
      color: PURPLE_SUMMARY_BACKGROUND
    );
  }

  Widget headers(Headers currentPage, VoidCallback navigateToRoot) {
    List<Color> headersColor = [];
    for (int i = 0; i < 5; i++) {
      if (Headers.values[i] == currentPage)
        headersColor.add(HEADER_HIGHLIGHT);
      else 
        headersColor.add(HEADER_DISABLED);
    }
    return 
      Container(
        color: Constants.PURPLE_THEME,
        constraints: BoxConstraints(minHeight: 100),
        child:
        Row(children: <Widget>[
          SizedBox(width: 180),
          // Progress
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              drawHeader("Personal Information", headersColor[0]),
              drawHeader("Address", headersColor[1]),
              drawHeader("Photo", headersColor[2]),
              drawHeader("Subject", headersColor[3]),
              drawHeader("Summary", headersColor[4]),            
            ]
          )), 
          // Cancel button
          SizedBox(width: 180, child: drawCancelButton(navigateToRoot))
    ])
    );
  }

  Widget drawCancelButton(navigateToRoot) {
    return
      Container(padding: const EdgeInsets.only(left: 0, top: 0, right: 60, bottom: 0),
          alignment: Alignment.centerRight,
          child: 
          Container(
            width: 45, 
            height: 45, 
            decoration: new BoxDecoration(
              color: Constants.PURPLE_THEME_DARK,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
              )
            ),
            child:
              IconButton(
                icon: Image(image: AssetImage('assets/images/cancel.png'), color: Colors.white),
                onPressed: () {
                  navigateToRoot();
                })
          ),
      );
  }

  Widget drawHeader(String name, Color color) {
    // if (color != Constants.HEADER_HIGHLIGHT) {
      return 
        Center(
          child: 
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
              child: Text(
                name,
                style: TextStyle(
                  color: color, 
                  fontFamily: 'Chivo',
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400
                ),
      )));
      // TODO: Can't put a line without pushing the text up
    // } else {
    //   return 
    //   Container(constraints: BoxConstraints(minHeight: 100), child:
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget> [
    //         Padding(
    //           padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
    //           child:
    //             Text(
    //               name,
    //               style: TextStyle(
    //                 color: color, 
    //                 fontFamily: 'Chivo',
    //                 fontSize: 18,
    //                 fontStyle: FontStyle.normal,
    //                 fontWeight: FontWeight.w400
    //             )),
    //         ),
    //         Padding(
    //           padding:EdgeInsets.only(bottom: 0),
    //           child:Container(
    //           height:2.0,
    //           width:30.0,
    //           color:Colors.white)),
    //         ]
    //   ));
    // }
  }
}