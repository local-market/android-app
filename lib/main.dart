import 'package:flutter/material.dart';
import 'package:local_market/utils/utils.dart';

import "package:local_market/views/login.dart";
import 'package:local_market/views/otp.dart';
import 'package:local_market/views/phone_verification.dart';
import 'package:local_market/views/search.dart';
import "package:local_market/views/signup.dart";
import "package:local_market/views/home.dart";
import "package:local_market/views/add_product.dart";
import 'package:local_market/views/update_product.dart';

void main() => runApp(
  new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Utils().colors['theme'],
      canvasColor: Utils().colors['drawerBackground']
    ),
    home: Login(),
  )
);