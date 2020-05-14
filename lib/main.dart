import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_queue_volunteer/ui/language_screen.dart';
import 'package:meet_queue_volunteer/ui/photo_screen.dart';
import 'package:meet_queue_volunteer/ui/root_page.dart';
import 'package:meet_queue_volunteer/ui/subject_screen.dart';
import 'package:meet_queue_volunteer/ui/summary_screen.dart';

import 'ui/address_screen.dart';
import 'ui/login_screen.dart';
import 'ui/personal_info_screen.dart';

var firstCamera;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  if (cameras.length > 1)
    firstCamera = cameras[1];
  else 
    firstCamera = cameras.first;

  runApp(
    EasyLocalization(
    child: MyApp(),
    supportedLocales: [
      // English
      Locale('en', 'SG'),
      // Mandarin
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'SG'),
      // Malay
      Locale('ms', 'SG'),
      // Tamil
      Locale('ta', 'SG'),
    ],
    path: 'assets/langs/langs.csv',
    assetLoader: CsvAssetLoader()
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // log(EasyLocalization.of(context).locale.toString(),
    //     name: '${this} # locale');

    SystemChrome.setEnabledSystemUIOverlays([]);
    // log(tr('clickMe').toString(), name: this.toString());
    return MaterialApp(
      title: 'Meet Queue Volunteer',
      localizationsDelegates:EasyLocalization.of(context).delegates,
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RootPage.routeName,
      routes: {
        RootPage.routeName: (context) => RootPage(),
        LoginScreen.routeName: (context) => LoginScreen(),
        LanguageScreen.routeName: (context) => LanguageScreen(),
        // Automatically dispose it when ChangeNotifierProvider is removed from the widget tree.
        PersonalInfoScreen.routeName: (context) => PersonalInfoScreen(),
        AddressScreen.routeName: (context) => AddressScreen(),
        PhotoScreen.routeName: (context) => PhotoScreen(camera: firstCamera),
        SubjectScreen.routeName: (context) => SubjectScreen(),
        SummaryScreen.routeName: (context) => SummaryScreen(),
      },
    );
  }
}
