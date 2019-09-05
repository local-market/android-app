import 'package:flutter/material.dart';
import 'package:local_market/views/product_view.dart';

class ProductListGenerator extends StatefulWidget {
  List<Map<String, String> > _products = new List<Map<String, String> >();

  ProductListGenerator(List<Map<String, String> > products){
    this._products = products;
  }

  @override
  _ProductListGeneratorState createState() => _ProductListGeneratorState(this._products);
}

class _ProductListGeneratorState extends State<ProductListGenerator> {
  List<Map<String, String> > _products;

  _ProductListGeneratorState(List<Map<String, String> > products){
    this._products = products;
  }
  @override
  Widget build(BuildContext context) {
    // print('Search Result Page' + _products.toString());
    return _products.length == 0 ? Center(child: Text("No record found"),) : ListView.separated(
      itemCount: _products.length,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductView(_products[index])));
            },
            leading: Image.network(_products[index]['image']),
            title: Text(_products[index]['name'])
          ),
        );
      },
      separatorBuilder: (context, index){
        return Divider(
          color: Colors.grey
        );
      },
    );
  }
}