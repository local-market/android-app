import 'package:local_market/components/cart_icon.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/views/home.dart';
import 'package:local_market/views/product_view.dart';
//import 'package:local_market/views/search.dart';
//import 'package:local_market/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/components/app_bar.dart';
//import 'package:local_market/components/page.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/search.dart';


class OrderStatus extends StatefulWidget {
  String orderId;
  final order_status_string=['Placed','Confirmed','Delivered'];

  OrderStatus(String orderId){
    this.orderId = orderId;
  }
  @override
  _OrderStatusState createState() => _OrderStatusState(this.orderId);
}

class _OrderStatusState extends State<OrderStatus> {
  final Utils _utils=new Utils();
  String orderId;

  _OrderStatusState(this.orderId);
  @override
  Widget build(BuildContext context) {

    return Page(
      appBar : RegularAppBar(
        backgroundColor: _utils.colors['appBar'],
        elevation: _utils.elevation,
        iconTheme: IconThemeData(color: _utils.colors['appBarIcons']),
        brightness: Brightness.light,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.search,
        //       color: _utils.colors['appBarIcons']
        //     ),
        //     onPressed: (){
        //       Navigator.push(context, CupertinoPageRoute(builder: (context) => Search()));
        //     },
        //   ),
        //   CartIcon()
        // ],
      ),
      bottomNavigationBar: Container(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Material(
//            borderRadius: BorderRadius.circular(20.0),
            color: _utils.colors['theme'],
            // elevation: _utils.elevation,
            child: MaterialButton(
              onPressed: () {
                  Navigator.pushReplacement(context, CupertinoPageRoute(builder:(context) => Home()));
              },
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                "Continue Shopping",
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
        PageItem(
          child: Page_content(this.orderId),
        )
      ],
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.red,
    //     title: Text('Order Status'),
    //     actions: <Widget>[
    //       new IconButton(
    //           icon: Icon(
    //             Icons.search,
    //             color: Colors.white,
    //           ),
    //           onPressed: () {}),
    //       new IconButton(
    //           icon: Icon(
    //             Icons.shopping_cart,
    //             color: Colors.white,
    //           ),
    //           onPressed: () {})
    //     ],
    //   ),
    //   body:Page_content(),
    // );
  }
}

class Page_content extends StatelessWidget {
  String orderId;
  Page_content(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Center(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:20.0),
              child:Center(
                child:Image.asset('assets/order/order.png',width:100.0,height:100.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 25, 8, 5),
              child: Center(
                child: Text(
                  "You order has been placed",
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(.0),
              child: Center(
                child: Text(
                  "Thank you for shopping",
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  "OrderId :",
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  this.orderId,
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ),
            )

            // Container(
            //   padding: EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0.0),
            //   child:Row(
            //     children: <Widget>[
            //       Expanded(
            //         child:Center(
            //             child:new Text('Placed',style:TextStyle(fontSize: 25.0),)
            //         ),
            //       ),
            //       Expanded(
            //         child:Center(
            //             child: new Text('Confirmed',style:TextStyle(fontSize: 25.0),)
            //         ),
            //       ),
            //       Expanded(
            //         child:Center(
            //           child:new Text('Delivered',style:TextStyle(fontSize: 25.0),),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   child:progression(),
            // ),
            // Container(
            //   padding:EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 30.0),
            //   child:new Text('Latest Update',style:TextStyle(fontSize: 25.0),),
            //   //color: Colors.lightBlueAccent,
            // ),
          ],
        )
    );
  }
}

class progression extends StatefulWidget {
  @override
  _progressionState createState() => _progressionState();
}

class _progressionState extends State<progression> {
  var progress=1;
  void change_status(changed_value){
    if(progress!=changed_value){
      progress=changed_value;
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(35.0,20.0,20.0,20.0),
      child: LinearProgressIndicator(
        value: progress*0.33,
        backgroundColor: Colors.white,
        valueColor:AlwaysStoppedAnimation<Color>(Colors.green,),
      ),
    );
  }
}

