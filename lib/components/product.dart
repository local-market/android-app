import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:local_market/components/add_button.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product_details.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/product_view.dart';

class Product extends StatefulWidget {

  var _product;
  bool _inner;

  Product(product, inner) {
    this._product = product;
    this._inner = inner;
  }

  @override
  _ProductState createState() => _ProductState(this._product, this._inner);
}

class _ProductState extends State<Product> {

  final Utils _utils = new Utils();

  var _product = null;
  int count = 0;
  bool _inner;

  _ProductState(product, _inner) {
    this._product = product;
    this._inner = _inner;
  }

  @override
  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
        return Card(
          child: Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .width / 2) - 40,
              // height: 110.0,
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 130,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context, CupertinoPageRoute(builder: (context) =>
                                ProductView(
                                    this._product
                                )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Image.network(
                                this._product['image'],
                                fit: BoxFit.cover,
                                // width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context, CupertinoPageRoute(builder: (context) =>
                                ProductView(
                                    this._product
                                )));
                          },
                          child: Container(
                            height: 37,
                            child: Text(
                              this._product['name'].length > 20 ? _utils.titleCase(this
                                  ._product['name'].substring(0, 20) + "...") : _utils.titleCase(this._product['name']),
                              style: TextStyle(
                                  fontSize: 15
                              ),

                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8, 8.0, 0),
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '₹${this._product['offerPrice']}  ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: _utils.colors['theme'],

                                    ),
                                  ),
                                  TextSpan(
                                    text: '₹${this._product['price']}',
                                    style: TextStyle(
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.shade700
                                    ),
                                  )
                                ]
                            ),
                          )
                        // Text('₹ ${this._product['price']}',
                        //   style: TextStyle(
                        //     fontSize: 15
                        //   ),
                        // ),
                      ),
                      AddButton(this._product, null, null, this._inner)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircleAvatar(
                      radius: 18,
                      child: Text(

                        "${(((double.parse(this._product['price']) - double.parse(this._product['offerPrice'])) / double.parse(this._product['price']) ) * 100) .ceil() }%\n off",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                        ),
                      ),backgroundColor: Colors.red.shade700,
                    ),
                  )
                ],
              )
          ),
        );



//      ],
//    );
  }
}