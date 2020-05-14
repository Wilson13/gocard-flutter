import 'package:flutter/material.dart';
import 'package:meet_queue_volunteer/bloc/login_bloc.dart';
import 'package:meet_queue_volunteer/helper.dart';
import 'package:meet_queue_volunteer/ui/language_screen.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  
  static const routeName = '/';

  RootPage();

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    super.initState();

    // If access token is found, user was signed in. Show home page.
    // Next step is supposed to be trying out the token to see if it's still valid.
    checkAuthToken();
  }

  void checkAuthToken() async {
    // Create storage
    // final storage = new FlutterSecureStorage();
  
    // Read value 
    // String value = await storage.read(key: Constants.AUTH_KEY);
    Helper helper = new Helper();
    String value = await helper.getAuthToken();

    if (!(["", null, false, 0].contains(value))) {
      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
    }
    else {
      setState(() {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      });
    }
  }

  void loginCallback() {
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });

    // Navigator.pushNamed(context, "/language");
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return ChangeNotifierProvider<LoginBloc>(
          create: (context) => LoginBloc(),
          child: 
          Consumer<LoginBloc>(builder: (context, bloc, child) {
            if (bloc.hasLoggedIn)
              return new LanguageScreen();
            else 
              return child;
            },
            child: new LoginScreen(loginCallback: loginCallback)
            // return new HomePage(
          //   items: List<ListItem>.generate(
          //     1000,
          //     (i) => i % 6 == 0
          //         ? HeadingItem("Heading $i")
          //         : MessageItem("Sender $i", "Message body $i"),
          //   ),
          //   // logoutCallback: logoutCallback,
          // );
        // } else
        //   return buildWaitingScreen();
          )
        );
        break;
      case AuthStatus.LOGGED_IN:
      return new LanguageScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}