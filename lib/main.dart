import 'package:flutter/material.dart';

import "package:local_market/views/login.dart";
import 'package:local_market/views/search.dart';
import "package:local_market/views/signup.dart";
import "package:local_market/views/home.dart";
import "package:local_market/views/add_product.dart";
import 'package:local_market/views/update_product.dart';

void main() => runApp(
  new MaterialApp(

    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.red.shade900
    ),
    home: Login(),
  )
);