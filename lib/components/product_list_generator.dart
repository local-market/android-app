import 'package:flutter/material.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/product_view.dart';
import 'package:local_market/views/update_product.dart';

class ProductListGenerator extends StatefulWidget {
  List<Map<String, String> > _products = new List<Map<String, String> >();
  bool _edit;

  ProductListGenerator(List<Map<String, String> > products, bool edit){
    this._products = products;
    this._edit = edit;
  }

  @override
  _ProductListGeneratorState createState() => _ProductListGeneratorState(this._products, this._edit);
}

class _ProductListGeneratorState extends State<ProductListGenerator> {
  List<Map<String, String> > _products;
  bool _edit;

  _ProductListGeneratorState(List<Map<String, String> > products, bool edit){
    this._products = products;
    this._edit = edit;
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
            title: Text(_products[index]['name']),
            trailing: _edit ? editButton(_products[index]['id'], _products[index]['name'], _products[index]['image']): Text('') ,
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

  Widget editButton(String productId, String productName, String productImageUrl){
    // print(productId +" : "+ productName +" : "+ productImageUrl);
    return IconButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProduct(productId, productName, productImageUrl)));
      },
      icon: Icon(Icons.edit,
      color: Utils().colors['icons'],),
    );
  }
}