import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meet_queue_volunteer/bloc/address_bloc.dart';
import 'package:meet_queue_volunteer/bloc/photo_bloc.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';
import 'package:meet_queue_volunteer/ui/subject_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:meet_queue_volunteer/helper.dart';
import 'package:flutter/painting.dart';
import 'package:path/path.dart' as Path;

import '../constants.dart';

class PhotoScreen extends StatefulWidget {

  static const routeName = '/photo';

  final CameraDescription camera;

  const PhotoScreen({@required this.camera});

  @override
  State<StatefulWidget> createState() => new _PhotoScreen();
}
  
class _PhotoScreen extends State<PhotoScreen>{

  CameraController _controller;
  Future<void> _initializeControllerFuture;
  PhotoBloc _photoBloc;
  Map<String, Object> passPhotoData;

  String _localPhotoPath;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => getPhoto());
    }
  }

  void getPhoto() {
    _photoBloc.getUserPhoto();
  } 

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  // final String token;
  final RegExp postalExp = new RegExp(
    r"^\d{6}$",
    caseSensitive: false,
    multiLine: false,
  );

  UserData userData;
  // String selectedValue;

  final Helper helper = new Helper();

  @override
  Widget build(BuildContext context) {
      
    // Extract the arguments from the current ModalRoute settings and cast
    // them as UserData.
    userData = ModalRoute.of(context).settings.arguments;
    _photoBloc = PhotoBloc(userData: userData);
    
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: makeBody()
    );
  }
    
  Widget makeBody() {
    return ChangeNotifierProvider<PhotoBloc>.value(
      value: _photoBloc,
      child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            // Header
            helper.headers(Headers.PHOTO, navigateToRoot),
            // Content column with three rows inside
            // Expanded(child: // Disable this if centered is required
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 60, top: 64, right: 60, bottom: 0),
              child: 
                Row(
                  children: <Widget> [
                  // Back button
                  showNavigationButton(true),
                  // Camera preview column
                  Expanded(child: cameraColumn()),
                  // Next button
                  showNavigationButton(false)
                ]
            ))
          ]
        )
      );    
  }

  Widget cameraColumn() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 450,
            height: 450,
            child: 
              Consumer<PhotoBloc>(builder: (context, photoBloc, child) {
                return FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // Camera is ready
                      if(photoBloc.photoPath == null) {
                        if (photoBloc.photoURL != null) {
                          // If no user photo exists on cloud
                          return Image.network(photoBloc.photoURL);
                        } else {
                          // If no photo was taken, show camera preview.
                          // No need to rotating, this only happens in emulator
                          // Transform.rotate(angle: - pi / 2, child: 
                          return CameraPreview(_controller);  
                        }
                      } else {
                        // If photo was taken, show image.
                        return Image.file(File(photoBloc.photoPath));
                      }
                    } else {
                      // Otherwise, display a loading indicator.
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                );
              }
            )
          )),
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: 
            SizedBox(
            width: 450,
            height: 76,
              child: Consumer<PhotoBloc>(builder: (context, photoBloc, child) {
                String buttonTxt = (photoBloc.photoPath != null || photoBloc.photoURL != null) ? 'Cancel' : 'Capture';
                return RaisedButton(
                  shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
                  color: PURPLE_THEME,
                  child: Text(
                    buttonTxt,
                    style: TextStyle(
                      color: Colors.white, 
                      fontFamily: 'SourceSansPro',
                      fontSize: 22,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal
                    )
                  ),
                  onPressed: () async {
                    imageCache.clear();
                    if (photoBloc.photoPath == null && photoBloc.photoURL == null) {
                      // User hasn't taken a photo on app, or has pressed cancel button
                      // when photo on cloud exists, meaning the button is capture button.
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Construct the path where the image should be saved using the
                        // pattern package.
                        _localPhotoPath = Path.join(
                          // Store the picture in the temp directory.
                          // Find the temp directory using the `path_provider` plugin.
                          (await getTemporaryDirectory()).path,
                          '${userData.uid}.jpg',
                        );

                        if (await File(_localPhotoPath).exists())
                          File(_localPhotoPath).deleteSync();

                        // Attempt to take a picture and log where it's been saved.
                        await _controller.takePicture(_localPhotoPath);
                        // Rotate image to correct orientation

                        // Pass photo to BLOC
                        photoBloc.setPath(_localPhotoPath);
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    } else {
                      // User has taken a photo on app, meaning the button is cancel button.
                      // Clear photo path
                      photoBloc.discardPhoto();
                    }
                  }
                );})
          ),
        )
    ]);
  }

  Widget showNavigationButton(bool isBack) {
    IconData iconData = isBack ? Icons.arrow_back_ios : Icons.arrow_forward_ios;

    // return Consumer<AddressBloc>(builder: (context, addressBloc, child) {
      return Container(
        decoration: 
          BoxDecoration(
            color: BLUE_ICON_BUTTON,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        child: 
          IconButton(
            icon: Icon(iconData, color: Colors.white),
            onPressed: () async {
              // Next button
              if (!isBack) {
                if (_photoBloc.photoPath == null && _photoBloc.photoURL == null) {
                  helper.displayToast("Please take a picture.");
                } else {
                  String uri = _photoBloc.isLocal ? _localPhotoPath : _photoBloc.photoURL;
                  passPhotoData = { 
                    "userData": _photoBloc.userData , 
                    "photoModel": new PhotoModel(isLocal: _photoBloc.isLocal, uri: uri)
                  };
                  // Instead of a simple push, push and replace so camera can be initialized and disposed properly.
                  Navigator.pushReplacementNamed(
                    context, 
                    SubjectScreen.routeName, 
                    arguments: passPhotoData);
                }
              } else {
                // Back button
                Navigator.pop(context);
              }
    }));
  }

  Widget showMsg() {
    return 
      Consumer<AddressBloc>(
        builder: (context, userBloc, child) {

          if (userBloc.msg != "User not found.")
            helper.displayToast(userBloc.msg);
          if (userBloc.errorMsg != "" && userBloc.errorMsg != "User not found.")
            helper.displayToast(userBloc.errorMsg);
          
          return Container();
      });
    }

  Widget drawCancelButton(context) {
    return
      Container(padding: const EdgeInsets.only(left: 0, top: 0, right: 60, bottom: 0),
          alignment: Alignment.centerRight,
          child: 
            IconButton(
              icon: Image(image: AssetImage('assets/images/cancel.png'), color: Colors.red),
              onPressed: () {
                navigateToRoot();
              }),
      );
  }

  void navigateToRoot() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}

class PhotoModel {
    bool isLocal;
    String uri;

    PhotoModel({
        @required this.isLocal,
        @required this.uri,
    });

    factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        isLocal: json["isLocal"],
        uri: json["uri"],
    );

    Map<String, dynamic> toJson() => {
        "isLocal": isLocal,
        "uri": uri,
    };
}