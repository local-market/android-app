import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/order_controller.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/utils/globals.dart' as globals;
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:local_market/views/order_status.dart';

class Payment extends StatefulWidget {
  String name,phone, address, landmark;

  Payment(String name, String phone, String address, String landmark){
    this.name = name;
    this.phone = phone;
    this.address = address;
    this.landmark = landmark;
  }
  @override
  _PaymentState createState() => _PaymentState(this.name, this.phone, this.address, this.landmark);
}

class _PaymentState extends State<Payment> {

  String name, phone, address, landmark;
  final Utils _utils = new Utils();
  final OrderController _orderController = new OrderController();
  final UserController _userController = new UserController();
  Map<String, dynamic> cart = new Map<String, dynamic> ();
  double total = 0;
  _PaymentState(this.name, this.phone,this.address, this.landmark);
  bool _loading = false;

  @override void initState() {
    super.initState();
    setState(() {
      this.cart= globals.cart;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: RegularAppBar(
        iconTheme: IconThemeData(
            color: _utils.colors['appBarIcons']
        ),
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        elevation: _utils.elevation,
        title: Text("Payment",
          style: TextStyle(
            color: _utils.colors['appBarText'],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Material(
//            borderRadius: BorderRadius.circular(20.0),
            color: _utils.colors['theme'],
            // elevation: _utils.elevation,
            child: _loading ? CircularLoadingButton() :  MaterialButton(
              onPressed: () async {
//                validateAndUpdate();
                  FirebaseUser _user = await UserController().getCurrentUser();
                  if(_user != null){
                    await _orderController.add(globals.cart, _user.uid.toString(), this.name, this.address, this.phone, this.landmark).then((orderId){
                      Navigator.pushReplacement(context, CupertinoPageRoute(builder:(context) => OrderStatus(orderId)));
                    }).catchError((e){
                      print('Payment Page Error: ${e.toString()}');
                    });
                  }
              },
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                "Place Order",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _utils.colors['buttonText'],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      children: <Widget>[
//        PageItem(
//          child: Text("Hello"),
//        )
//        PageList(
//          children: <Widget>[
//            Text("Hello")
//          ],
//        )
        PageList(
          children : <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 8, 8),
              child: Text("Shipping details: "),
            ),
            ListTile(
              title: Text(
                this.name
              ),
              subtitle: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Text(this.phone),
                  Text(this.address),
                  Text(this.landmark)
                ],
              ),
            ),
          ]
        ),

        PageList.builder(
            itemCount: this.cart.length,
            itemBuilder: (context,i){
              // total += double.parse(this.cart[index]['discountedprice']);
              // total = 0;
              var keys = this.cart.keys.toList();
//            this.total += double.parse(this.cart[keys[i]]['data']['price']) * double.parse(this.cart[keys[i]]['count']);
              return product_instance_cart(this.cart[keys[i]]['data']["id"],
                this.cart[keys[i]]['data']["image"],
                this.cart[keys[i]]['data']["name"],
                this.cart[keys[i]]['data']["price"],
                this.cart[keys[i]]['data']["price"],
                this.cart[keys[i]]['count']

              );
            }
        ),
        PageItem(

          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Items',style: TextStyle(fontSize: 16),),
                    Text(globals.total.toString(),style: TextStyle(fontSize: 16),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Delivery',style: TextStyle(fontSize: 16),),
                    Text('20',style: TextStyle(fontSize: 16),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total',style: TextStyle(fontSize: 16),),
                    Text((globals.total+20).toString(),style: TextStyle(fontSize: 16),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Promo(Free Delivery)',style: TextStyle(fontSize: 16),),
                    Text('-20',style: TextStyle(fontSize: 16),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Order Total',style: TextStyle(fontSize: 16),),
                    Text(globals.total.toString(),style: TextStyle(fontSize: 16),)
                  ],
                ),
              ],
            ),
          ),
        ),
        PageList(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 8, 15.0, 8),
              child: Text("Payment Options",
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            ),
            ListTile(
              title: Text("Cash on delivery"),
              leading: new Radio(
                value: 0,
                groupValue: 0,
                activeColor: _utils.colors['theme'],
                onChanged: (value){

                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget product_instance_cart(prod_id,prod_image, prod_name, prod_price, prod_discountedprice,prod_count) {
    return Card(
      child: ListTile(
        leading: new Image.network(prod_image,
          width: 100.0,
          // height: 150.0,
          // fit: BoxFit.cover,
        ),
        title: new Text(
          prod_name.length > 30
              ? prod_name.substring(0, 30) + "..."
              : prod_name,
          style: TextStyle(fontSize: 15.0),),
        subtitle: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text("Price:",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                  child: new Text('Rs $prod_price',
                    style: TextStyle(color: Colors.green, fontSize: 13.0),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 8.0, 8.0),
                  child: new Text("Discounted Price:",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 8.0),
                  child: new Text('Rs $prod_discountedprice',
                    style: TextStyle(color: Colors.red, fontSize: 13.0),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 8.0),
                  child: new Text('Quantity $prod_count',
                    style: TextStyle( fontSize: 13.0),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
