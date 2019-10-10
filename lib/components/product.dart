import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product_details.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/product_view.dart';

class Product extends StatelessWidget {

  final Utils _utils = new Utils();

  Map<String, String> _product = null;

  Product(Map<String, String> product){
    this._product = product;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
  child: Container(
    width: 170.0,
    // height: 250.0,
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 210,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductView(
                    this._product
                  )));
                },
                child: Image.network(
                  this._product['image'],
                  fit: BoxFit.cover,
                  width: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                this._product['name'].length > 45 ? this._product['name'].substring(0, 45) + "..." : this._product['name'],
                style: TextStyle(
                  fontSize: 18
                ),
                  
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('₹ ${this._product['price']}',
                style: TextStyle(
                  fontSize: 22
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(0.0),
                color: _utils.colors['theme'],
                // elevation: _utils.elevation,
                child: MaterialButton(
                  onPressed: () {
                    
                  },
                  
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "ADD",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _utils.colors['buttonText'],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        )
      ),
              
    );
  }
}