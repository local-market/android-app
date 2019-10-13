import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product_list_generator.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Map<String, String>> _products = new List<Map<String, String>>();
  // final UserController _userController = new UserController();
  final Utils _utils = new Utils();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // check();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: RegularAppBar(
        elevation: _utils.elevation,
        brightness: Brightness.light,
        backgroundColor: _utils.colors['appBar'],
        iconTheme: IconThemeData(
          color:_utils.colors['appBarIcons']
        ),
        title: Text("My Orders",
          style: TextStyle(
            color: _utils.colors['appBarText']
          ),
        ),

      ),
      children: <Widget>[
        PageItem(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text("Id: 31te2re12re1y52e1r", style: TextStyle(fontSize: 25),),
          ),
        ),
        PageItem(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text("Id: 45dh45dh45dth14", style: TextStyle(fontSize: 25),),
          ),
        )
      ],
    );
  }

  // void check() async {
  //   if(!(await _utils.isLoggedIn())){
  //     Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login()));
  //   }
  // }
}
