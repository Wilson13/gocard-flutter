
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perks_card/bloc/home_bloc.dart';
import 'package:perks_card/ui/home_screen.dart';
import 'package:perks_card/ui/map_screen.dart';
import 'package:perks_card/ui/payment_confirm_screen.dart';
import 'package:perks_card/ui/payment_summary_screen.dart';
import 'package:perks_card/ui/picture_screen.dart';
import 'package:perks_card/ui/qr_screen.dart';
import 'package:provider/provider.dart';

import 'bloc/login_bloc.dart';
import 'bloc/payment_bloc.dart';
import 'ui/login_screen.dart';

var firstCamera;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras. (front camera)
  if (cameras.length > 1)
    firstCamera = cameras[1];
  else 
    firstCamera = cameras.first;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perks Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.routeName,//RootPage.routeName,
      routes: {
        // Automatically dispose it when ChangeNotifierProvider is removed from the widget tree.
        LoginScreen.routeName: (context) =>  ChangeNotifierProvider<LoginBloc>(
          create: (context) => LoginBloc(),
          child: LoginScreen()),
        PictureScreen.routeName: (context) => PictureScreen(camera: firstCamera),
        HomeScreen.routeName: (context) => Provider<HomeBloc>(
          create: (context) => HomeBloc(),
          child: HomeScreen()
          ),
        MapScreen.routeName: (context) => MapScreen(),
        QRScreen.routeName: (context) => QRScreen(),
        PaymentSummaryScreen.routeName: (context) => PaymentSummaryScreen(),
        PaymentConfirmScreen.routeName: (context) => 
          Provider<PaymentBloc>(
            create: (context) => PaymentBloc(),
            child: PaymentConfirmScreen()
          ),
      },
    );
  }
}
