import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final currency_symbol = {
    "rupee": '₹',
  };
  final prod_name;
  final prod_pricture;
  final prod_old_price;
  final prod_price;
  final currency;

  ProductDetails({
    this.prod_name,
    this.prod_pricture,
    this.prod_old_price,
    this.prod_price,
    this.currency,
  });
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Apni dukan'),
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
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Image.asset(widget.prod_pricture),
            ),
          ),

          ListTile(
            leading: Text(
              widget.prod_name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            title: Text(
              "${widget.currency_symbol[widget.currency]} ${widget.prod_price}",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              "${widget.currency_symbol[widget.currency]} ${widget.prod_old_price}",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w800,
                  decoration
                      :TextDecoration.lineThrough),
            ),
        ),
        ],
      ),
    );
  }
}
