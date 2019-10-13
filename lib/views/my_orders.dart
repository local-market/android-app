import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product_list_generator.dart';
import 'package:local_market/controller/order_controller.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/order.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Map<String, String>> _products = new List<Map<String, String>>();
  final UserController _userController = new UserController();
  final OrderController _orderController = new OrderController();
  List<DocumentSnapshot> _orders = new List<DocumentSnapshot>();
  final Utils _utils = new Utils();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _userController.getCurrentUser().then((user){
      if(user != null){
        _orderController.getByUserId(user.uid.toString()).then((orders){
          print(orders[0].data.toString());
          setState(() {
            this._orders = orders;
            this._loading = false;
          });
        });
      }
    });
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
        this._loading ? PageItem(child: SpinKitCircle(color: _utils.colors['theme'],),):PageList.builder(
          itemCount: this._orders.length,
          itemBuilder: (context, i){
            return InkWell(
              onTap: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context) => Order(this._orders[i].data)));
              },
              child: ListTile(
                title: Text(
                  this._orders[i].data['id']
                ),
              ),
            );
          }
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
