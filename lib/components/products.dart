import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/components/page.dart';


import 'package:local_market/components/product_details.dart';
import 'package:local_market/utils/utils.dart';


class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_list = [
    {
      "name": "Red dress",
      "picture": "assets/products/dress1.jpeg",
      "old_price": 100,
      "price": 50,
      "currency":"rupee",
    },
    {
      "name": "Black",
      "picture": "assets/products/dress2.jpeg",
      "old_price": 120,
      "price": 85,
      "currency":"rupee",
    },
    {
      "name": "Blazer 1",
      "picture": "assets/products/blazer1.jpeg",
      "old_price": 120,
      "price": 85,
      "currency":"rupee",
    },
    {
      "name": "Blazer 2",
      "picture": "assets/products/blazer2.jpeg",
      "old_price": 120,
      "price": 85,
      "currency":"rupee",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return PageGrid.builder(
      itemCount: product_list.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index){
        return Single_prod(
          prod_name: product_list[index]['name'],
          prod_pricture: product_list[index]['picture'],
          prod_old_price: product_list[index]['old_price'],
          prod_price: product_list[index]['price'],
          currency: product_list[index]['currency'],
        );
      },
    );
  }
}

class Single_prod extends StatelessWidget {
  final currency_symbol = {
    "rupee": '₹',
  };
  final prod_name;
  final prod_pricture;
  final prod_old_price;
  final prod_price;
  final currency;

  Single_prod({
    this.prod_name,
    this.prod_pricture,
    this.prod_old_price,
    this.prod_price,
    this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: prod_name,
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(
            new CupertinoPageRoute(builder: (context) => new ProductDetails(
              prod_name: prod_name,
              prod_pricture: prod_pricture,
              prod_old_price: prod_old_price,
              prod_price: prod_price,
              currency: currency,
            ))),
              child: GridTile(
                  footer: Container(
                    color: Utils().colors['pageBackground'],
                    child: ListTile(
                        leading: Text(
                          prod_name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          "${currency_symbol[currency]} $prod_price",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          "${currency_symbol[currency]} $prod_old_price",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w800,
                              decoration
                                  :TextDecoration.lineThrough),
                        ),
                    ),
                  ),
                  child: Image.asset(
                    prod_pricture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}
