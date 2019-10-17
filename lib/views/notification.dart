import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/request_priduct_item.dart';
import 'package:local_market/controller/notification_controler.dart';
import 'package:local_market/controller/order_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/cart.dart';
import "package:local_market/views/signup.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:local_market/views/home.dart";
import 'package:outline_material_icons/outline_material_icons.dart';

class ProductRequests extends StatefulWidget {
  @override
  _ProductRequestsState createState() => _ProductRequestsState();
}

class _ProductRequestsState extends State<ProductRequests> {
  final NotificationController _notificationController =
      new NotificationController();
  List<Map<String, String>> _orders = new List<Map<String, String>>();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _OldPasswordTextController =
      new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Utils _utils = new Utils();
  
  var _loading = true;
  var _orderCount = -1;

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: RegularAppBar(
        elevation: _utils.elevation,
        brightness: Brightness.light,
        backgroundColor: _utils.colors['appBar'],
        iconTheme: IconThemeData(color: _utils.colors['appBarIcons']),
        title: Text(
          "Notifications",
          style: TextStyle(color: _utils.colors['appBarText']),
        ),
      ),
      children: <Widget>[
        this._loading
            ? PageItem(
                child: SpinKitCircle(
                  color: _utils.colors['theme'],
                ),
              )
            : PageList.builder(
                itemCount: this._orders.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {},
                    child: RequestItem(
                        prod_name: _orders[i]['productName'].toString(),
                        prod_price: _orders[i]['prodPrice'].toString(),
                        prod_image: _orders[i]["productImage"].toString(),
                        order_time: _orders[i]['dateTime'].toString(),
                        prod_quantity: _orders[i]['quantity'].toString()),
                  );
                }),
        this._orderCount == 0
            ? PageItem(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "No Order Fount",
                        style: TextStyle(
                            color: _utils.colors['searchBarIcons'],
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    )),
              )
            : PageItem(
                child: Text(""),
              )
      ],
    );

    /*
    Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: _utils.colors['appBarIcons']),
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        elevation: 0,
        title: Text(
          "Product Requests",
          style: TextStyle(
            color: _utils.colors['appBarText'],
          ),
        ),
      ),
      backgroundColor: _utils.colors['pageBackground'],
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[

                  

                  // RequestItem(
                  //   prod_name:_orders[0]["productName"].toString(),
                  //   prod_price:_orders[0]["prodPrice"].toString(),
                  //   prod_image:"Image",
                  //   order_time:_orders!=null?_orders[0]["date"].toString():"time",
                  // ),

                  RequestItem(
                    prod_name:"Dal (moong)",
                    prod_price:"150",
                    prod_image:"https://firebasestorage.googleapis.com/v0/b/local-market-454fa.appspot.com/o/060618b0-ed20-11e9-a8b2-d12a53b0c76d?alt=media&token=7d284344-05bc-4dc8-b300-12202add1df8",
                    order_time:"5:40 PM",
                    prod_quantity: "1 kg"
                  ),

                  

                  // Padding(
                  //   padding: const EdgeInsets.all(10),
                  //   child: Material(
                  //     borderRadius: BorderRadius.circular(5.0),
                  //     color: _utils.colors['textFieldBackground'].withOpacity(0.9),
                  //     elevation: _utils.elevation,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: ListTile(
                  //         title: TextFormField(
                  //           controller: _OldPasswordTextController,
                  //           obscureText: hidePassword1,
                  //           autofocus: false,
                  //           decoration: InputDecoration(
                  //               hintText: "Current Password",
                  //               icon: Icon(OMIcons.lock),
                  //                 suffixIcon: IconButton(icon: Icon(OMIcons.removeRedEye), onPressed: (){
                  //                   setState(() {
                  //                     hidePassword1 = !hidePassword1;
                  //                   });
                  //                 }),
                  //               // border: InputBorder.none
                  //               ),
                  //           keyboardType: TextInputType.emailAddress,
                  //           validator: (value) {
                  //             if (value.isEmpty) {
                  //               return "This field cannot be empty";
                  //             } else if (value.length < 6)
                  //               return "Should be more than 6 length";
                  //             else
                  //               return null;
                  //           },
                  //         ),
                  //         // trailing:
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(error, style: TextStyle(
                          color: _utils.colors['error'], fontWeight: FontWeight.w400, fontSize: 14
                      ),),
                    )
                  ),

                  //
                ],
              ),
            ),
          ),
        ],
      ),
    );
    */
  }

  @override
  void initState() {
    super.initState();
    this._notificationController.getAll().then((orders) {
      debugPrint(orders.toString());
      // orders.add({
      //   "id" : "Id",
      //   "orderId" : "order",
      //   "username" : "username",
      //   "code" : "code",
      //   "productId" : "pid",
      //   "productName" : "Dal (moong)",
      //   "productImage" : "https://firebasestorage.googleapis.com/v0/b/local-market-454fa.appspot.com/o/060618b0-ed20-11e9-a8b2-d12a53b0c76d?alt=media&token=7d284344-05bc-4dc8-b300-12202add1df8",
      //   "quantity" : "Qul",
      //   "prodPrice" : "100",
      //   "dateTime" : "10:50 PM"
      //   });
      setState(() {
        this._orders = orders;
        this._loading = false;
        this._orderCount = orders.length;
      });
    });
  }
}
