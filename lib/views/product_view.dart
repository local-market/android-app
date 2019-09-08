import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/search.dart';

// image row and its properties
class image extends StatelessWidget {

  Map<String, String> _product;
  image(Map<String, String> product){
    this._product = product;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Center(
        child: Image.network(_product['image'], width:200)
      ),
    );
    //return Container(
    //  margin: EdgeInsets.all(10),
    //  height: 150,
    //  child: Image.network(_product['image']),
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
   // );
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
  final Utils _utils = new Utils();

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

    return Page(
      appBar: RegularAppBar(
        backgroundColor: _utils.colors['appBar'],
        elevation: _utils.elevation,
        iconTheme: IconThemeData(color: _utils.colors['appBarIcons']),
        brightness: Brightness.light,
        // title: Text(
        //   _product['name'],
        //   style: TextStyle(
        //     color: _utils.colors['appBarText']
        //   ),
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: _utils.colors['appBarIcons']
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
            },
          )
        ],
      ),
      children: <Widget>[
        _loading ? PageList(
          children: <Widget>[
            ListTile(
              title:image(_product),

            ),
            Center(
              child: SpinKitCircle(color: _utils.colors['loading']),
            )
          ],
        ) : PageList.separated(
        // shrinkWrap: true,
        itemCount: _vendors.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title:image(_product),
            );
          }else if(index == 1){
            return ListTile(
              title: Text(_product['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              )
            );
          }
          else {
            print('product view loading: ' + _loading.toString());
            if(_loading){
              return Center(child: SpinKitCircle(color: _utils.colors['loading']));
            }else{
              return ListTile(
                title: decorate(
                  listTileItem(_vendors[index - 2]['name'],_vendors[index - 2]['price']),
                ),
              );
            }
          }
        },
      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
        ),
      ],
    );
  }
}
