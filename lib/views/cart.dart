import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/search.dart';
import 'package:local_market/utils/globals.dart' as globals;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  Map<String, dynamic> cart = new Map<String, dynamic> ();

  final Utils _utils = new Utils();

  @override
  void initState() {
    super.initState();

    setState(() {
      this.cart = globals.cart;
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
                  subtitle: Text("0",style: TextStyle(color:_utils.colors['theme'],fontWeight:FontWeight.bold,fontSize: 16.0),),
                ),
              ),
              Expanded(
                child:new MaterialButton(onPressed: (){},
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
            return new product_instance_cart(
              prod_name:this.cart[keys[i]]['data']["name"],
              prod_price:this.cart[keys[i]]['data']["price"],
              prod_image:this.cart[keys[i]]['data']["image"],
              prod_discountedprice:this.cart[keys[i]]['data']["price"],
              prod_seller:this.cart[keys[i]]['data']["vendorName"],
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
}

class product_instance_cart extends StatelessWidget {
  final String prod_name,prod_price,prod_image,prod_discountedprice,prod_seller;
  product_instance_cart({this.prod_name,this.prod_price,this.prod_image,this.prod_discountedprice,this.prod_seller});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: new Image.network(prod_image,
        width: 100.0,
        // height: 150.0,
        // fit: BoxFit.cover,
        ),
        title: new Text(
          prod_name.length > 30 ? prod_name.substring(0, 30) + "..." : prod_name,
          style: TextStyle(fontSize: 15.0),),
        subtitle:new Column(
          children:<Widget>[
            new Row(
              children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(4.0),
                   child:new Text("Price:",
                     style: TextStyle(fontSize: 13.0),
                   ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                  child:new Text('Rs $prod_price',
                    style: TextStyle(color:Colors.green,fontSize: 13.0),
                  ),
                ),

                ],
                ),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 8.0, 8.0),
                  child:new Text("Discounted Price:",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 8.0),
                  child:new Text('Rs $prod_discountedprice',
                    style: TextStyle(color:Colors.red,fontSize: 13.0),
                  ),
                ),
              ],
            ),
            new Container(
              alignment: Alignment.topLeft,
              child:new Text(
                ' $prod_seller',style:TextStyle(fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
              ],
            ),
        trailing: Icon(
            Icons.close,
            color: Utils().colors['icons'],
          ),
        ),
    );
  }
}