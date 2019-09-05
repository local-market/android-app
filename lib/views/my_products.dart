import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/product_list_generator.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';

import 'login.dart';

class MyProducts extends StatefulWidget {
  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  List<Map<String, String> > _products = new List<Map<String, String> >();
  final UserController _userController = new UserController();
  final Utils _utils = new Utils();
  bool _loading = false;

  @override
  void initState(){
    super.initState();
    check();
    fillProducts();
  }

  void fillProducts() async {
    _loading = true;
    FirebaseUser user = await _userController.getCurrentUser();
    _userController.getAllProducts(user.uid.toString()).then((products){
      // print(products);
      setState(() {
        _products = products;
        // print(products.toString());
        // print(_products.toString());
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Product"),
        backgroundColor: Colors.red,
      ),
      body: _loading ? SpinKitCircle(color: Colors.red) : ProductListGenerator(_products),
    );
  }

  void check() async {
    if(!(await _utils.isLoggedIn())){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}