import 'package:flutter/material.dart';

import "package:local_market/views/login.dart";
import "package:local_market/views/signup.dart";
import "package:local_market/views/home.dart";

void main() => runApp(
  new MaterialApp(

    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.red.shade900
    ),
    home: Login()
  )
);