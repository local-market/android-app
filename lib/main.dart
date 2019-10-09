import 'package:flutter/material.dart';
import 'package:local_market/utils/utils.dart';
import "package:local_market/views/home.dart";
import 'package:flutter/services.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.light,
  ));
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Utils().colors['theme'],
        canvasColor: Utils().colors['drawerBackground']
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Home()
      ),
    )
  );
}