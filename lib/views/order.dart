import 'package:local_market/views/product_view.dart';
//import 'package:local_market/views/search.dart';
//import 'package:local_market/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/components/app_bar.dart';
//import 'package:local_market/components/page.dart';
import 'package:local_market/utils/utils.dart';


class OrderStatus extends StatefulWidget {
  final order_status_string=['Placed','Confirmed','Delivered'];
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  final Utils _utils=new Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Order Status'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      body:Page_content(),
    );
  }
}

class Page_content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:20.0),
              child:Center(
                child:Image.asset('assets/orderstatus/order.png',width:100.0,height:100.0),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0.0),
              child:Row(
                children: <Widget>[
                  Expanded(
                    child:Center(
                        child:new Text('Placed',style:TextStyle(fontSize: 25.0),)
                    ),
                  ),
                  Expanded(
                    child:Center(
                        child: new Text('Confirmed',style:TextStyle(fontSize: 25.0),)
                    ),
                  ),
                  Expanded(
                    child:Center(
                      child:new Text('Delivered',style:TextStyle(fontSize: 25.0),),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child:progression(),
            ),
            Container(
              padding:EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 30.0),
              child:new Text('Latest Update',style:TextStyle(fontSize: 25.0),),
              //color: Colors.lightBlueAccent,
            ),
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

