import 'package:flutter/material.dart';

class RequestItem extends StatelessWidget {
  final String prod_name, prod_price, prod_image, prod_quantity, order_time;

  RequestItem(
      {this.prod_name, this.prod_price, this.prod_image, this.prod_quantity, this.order_time});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(prod_image,
          width: 60.0,
          // height: 0.0,
          // fit: BoxFit.cover,
        ),
        title: new Text(
          "$prod_name ",
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text(
                    "Price: ",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: new Text(
                    'Rs $prod_price',
                    style: TextStyle(color: Colors.green, fontSize: 13.0),
                  ),
                ),
              ],
            ),

            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: new Text(
                    "Quantity: ",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                  child: new Text(
                    prod_quantity.toString(),
                    style: TextStyle(color: Colors.green, fontSize: 13.0),
                  ),
                ),
              ],
            ),
            new Container(
              alignment: Alignment.topLeft,
              child: new Text(
                '$order_time',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }
}
