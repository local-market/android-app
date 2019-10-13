import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/components/add_button.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/customer_details.dart';
import 'package:local_market/views/login.dart';
import 'package:local_market/views/search.dart';
import 'package:local_market/utils/globals.dart' as globals;
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  Map<String, dynamic> cart = new Map<String, dynamic> ();

  final Utils _utils = new Utils();
  final UserController _userController = new UserController();
  DocumentSnapshot _user;
  double total = 0;

  void updateTotal(){
    setState(() {
      this.total = globals.total;
    });
  }

  @override
  void initState() {
    super.initState();

    _userController.getCurrentUserDetails().then((user){
      setState(() {
        this._user = user;
      });
    });

    setState(() {
      this.total = globals.total;
    });
//    this.cart.map((key, object){
//      setState(() {
//        print(object.toString());
//        this.total
//      });
//    });



    setState(() {
      this.cart = globals.cart;
    });

    new Timer.periodic(const Duration(seconds: 1), (Timer t){
      setState(() {
        this.total = globals.total;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: RegularAppBar(
        backgroundColor: _utils.colors['appBar'],
        elevation: _utils.elevation,
        iconTheme: IconThemeData(color: _utils.colors['appBarIcons']),
        brightness: Brightness.light,
        // title: Text(
        //   _product['name'],
        //   style: TextStyle(
        //     color: _utils.colors['appBarText']
        //   ),
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: _utils.colors['appBarIcons']
            ),
            onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context) => Search()));
            },
          ),
        ],
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text("Total",style: TextStyle(fontSize: 20.0),),
                  subtitle: Text(this.total.toString(),style: TextStyle(color:_utils.colors['theme'],fontWeight:FontWeight.bold,fontSize: 16.0),),
                ),
              ),
              Expanded(
                child:new MaterialButton(onPressed: (){
                  if(this._user == null){
                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login("cart")));
                  }else{
                    Navigator.push(context,CupertinoPageRoute(builder: (context)=> CustomerDetails()));
                  }
                },
                  child:new Text("Check Out",style: TextStyle(color: Colors.white,fontSize: 20.0),),
                  color: _utils.colors['theme'],
                ),
              ),
            ],
          ),
        ),
      ),
      children: 
      
      <Widget>[
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

            );
          }
        )
      ],
    );
  }

  // List<Widget> generateList() {
  //   List<Widget> results = new List<Widget>();
  //   var keys = this.cart.keys.toList();
  //   for(int i = 0; i < this.cart.length; i++){
  //     print(this.cart[keys[i]]['data']);
  //     results.add(
  //       product_instance_cart(
  //         prod_name:this.cart[keys[i]]['data']["name"],
  //         prod_price:this.cart[keys[i]]['data']["price"],
  //         prod_image:this.cart[keys[i]]['data']["image"],
  //         prod_discountedprice:this.cart[keys[i]]['data']["price"],
  //         prod_seller:this.cart[keys[i]]['data']["vendorName"],
  //       )
  //     );
  //   }
  //   print("Cart" + results.toString());
  //   return results;
  // }

  Widget product_instance_cart(prod_id,prod_image, prod_name, prod_price, prod_discountedprice) {
    return Card(
      child: ListTile(
        leading: new Image.network(prod_image,
          width: 60.0,
          // height: 0.0,
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
            new Container(
                alignment: Alignment.topLeft,
                child: AddButton(this.cart[prod_id]['data'], null)
            ),
          ],
        ),
        trailing: InkWell(
          onTap: () {
            globals.total -= double.parse(globals.cart[prod_id]['data']['price']) * double.parse(globals.cart[prod_id]['count']);
            globals.cartSize -= int.parse(globals.cart[prod_id]['count']);
            globals.cart[prod_id]['clearCount']();
            globals.cart.remove(prod_id);

            setState(() {
              this.cart = globals.cart;
              this.total = globals.total;
            });
          },
          child: Icon(
            OMIcons.delete,
            color: Utils().colors['icons'],
          ),
        ),
      ),
    );
  }
}