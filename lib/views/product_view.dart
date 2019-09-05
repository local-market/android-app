import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/controller/product_controller.dart';

// image row and its properties
class image extends StatelessWidget {

  Map<String, String> _product;
  image(Map<String, String> product){
    this._product = product;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(10),
      height: 150,
      child: Image.network(_product['image']),
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/notebooks.jpg'),
      //     fit: BoxFit.fill,
      //   ),
      //   color: Colors.white,
      //   borderRadius: new BorderRadius.all(Radius.circular(20.0)),
      //   border: Border.all(
      //     color: Colors.black,
      //     width: 6.0,
      //   ),
      // ),
    );
  }
}

Widget decorate(Widget input) {
  return Material(
    // color: Colors.grey[900],
    child: InkWell(
      onTap: (){
        print('Tapped');
      },
      child: Container(
        height: 75,
        padding: EdgeInsets.only(left: 15, right: 15),
        //color: Colors.lightBlueAccent,
        //padding: EdgeInsets.all(5),
        child: input,
      ),
    ),
  );
}

class ItemName extends StatelessWidget {

  String itemname;

  ItemName(Map<String, String> product){
    this.itemname = product['name'];
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(itemname,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            // color: Colors.white
          )
        )
      );
  }
}

List<List<String>> getShop() {
  var items = List<List<String>>.generate(50,
      (counter) => ['Shop_$counter', 'Distance_$counter', 'Price_$counter']);
  return items;
}

// Widget getListView(Map<String, String> _product, List<Map<String, String> > _vendors) {
//   var listview = 
//   return listview;
// }

Widget listTileItem(item, price) {
  return Row(
    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Center(
          child: Text(
            item,
            style: TextStyle(fontSize: 20, 
            // color: Colors.lightGreenAccent
            ),
          ),
        ),
      ),
      // Expanded(
      //   child: Center(
      //     child: Text(
      //       distance,
      //       style: TextStyle(fontSize: 20, 
      //       // color: Colors.lightGreenAccent
      //       ),
      //     ),
      //   ),
      // ),
      Expanded(
        child: Center(
          child: Text(
            price,
            style: TextStyle(fontSize: 20, 
            // color: Colors.lightGreenAccent
            ),
          ),
        ),
      ),
    ],
  );
}

class tableHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'ShopName',
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    // color: Colors.lightGreenAccent
                  ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Distance',
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    // color: Colors.lightGreenAccent
                  ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Price',
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    // color: Colors.lightGreenAccent
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductView extends StatefulWidget {
  Map<String, String> _product;

  ProductView(Map<String, String> _product){
    this._product = _product;
  }
  @override
  _ProductViewState createState() => _ProductViewState(_product);
}
// scaffold for the whole app level column
class _ProductViewState extends State<ProductView> {

  Map<String, String> _product;
  List<Map<String, String> > _vendors = new List<Map<String, String> >();
  final ProductController _productController = new ProductController();
  bool _loading = true;

  _ProductViewState(Map<String, String> product){
    this._product = product;
  }

  @override
  void initState(){
    super.initState();
    _productController.getVendors(_product['id']).then((value){
      setState(() {
        this._vendors = value;
        _loading = false;
        // print("vendors details : " + value.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          _product['name'],
        ),
      ),
      body: _loading ? ListView(
          children: <Widget>[
            ListTile(
              title:image(_product),
            ),
            Center(
              child: SpinKitCircle(color: Colors.red),
            )
          ],
        ) : ListView.separated(
      itemCount: _vendors.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            title: image(_product),
          );
        } 
        else {
          print('product view loading: ' + _loading.toString());
          if(_loading){
            return Center(child: SpinKitCircle(color: Colors.red));
          }else{
            return ListTile(
              title: decorate(
                listTileItem(_vendors[index - 1]['name'],_vendors[index - 1]['price']),
              ),
            );
          }
        }
      },
    separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
      ),
      // backgroundColor: Colors.grey[900],
    );
  }
}
