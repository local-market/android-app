import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:local_market/utils/utils.dart';
import "package:local_market/views/home.dart";
import 'package:local_market/components/counter.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.light,
  ));


// Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;


  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Utils().colors['theme'],
        canvasColor: Utils().colors['drawerBackground']
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,

        /// replacing Home with counter
        child: TakePictureScreen(camera: firstCamera,)
      ),
    )
  );
}