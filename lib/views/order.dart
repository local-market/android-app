import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/order_controller.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';

class Order extends StatefulWidget {
  var _order;
  Order(order){
    this._order = order;
  }
  @override
  _OrderState createState() => _OrderState(this._order);
}

class _OrderState extends State<Order> {
  var _order;
  List<DocumentSnapshot> _products = new List<DocumentSnapshot>();
  final Utils _utils = new Utils();
  final OrderController _orderController = new OrderController();
  bool _loading = false;
  double total = 0;

  _OrderState(this._order);

  @override
  void initState() {
    super.initState();
    _orderController.getOrderProducts(this._order['id']).then((products){
      setState(() {
        this._products = products;  
      });
      double temp = 0;
      for(var i = 0; i < _products.length; i++){
        temp += double.parse(_products[i]['price']) * double.parse(_products[i]['quantity']);
      }
      setState((){
        this.total = temp;
      });
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
        title: Text("Order",
          style: TextStyle(
            color: _utils.colors['appBarText'],
          ),
        ),
      ),
      children: <Widget>[
        PageList(
          children : <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 8, 8),
              child: Text("Shipping details: "),
            ),
            ListTile(
              title: Text(
                this._order['username']
              ),
              subtitle: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Text(this._order['phone']),
                  Text(this._order['address']),
                  Text(this._order['landmark'])
                ],
              ),
            ),
          ]
        ),

        PageList.builder(
            itemCount: this._products.length,
            itemBuilder: (context,i){
              return product_instance_cart(this._products[i]["id"],
                this._products[i]["image"],
                this._products[i]["name"],
                this._products[i]["price"],
                this._products[i]["price"],
                this._products[i]['quantity']
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
                    Text(this.total.toString(),style: TextStyle(fontSize: 16),)
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
                    Text((this.total+20).toString(),style: TextStyle(fontSize: 16),)
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
                    Text(this.total.toString(),style: TextStyle(fontSize: 16),)
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
