import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/add_button.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/cart_icon.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/add_vendor_to_product.dart';
import 'package:local_market/views/search.dart';
import 'package:local_market/utils/globals.dart' as globals;

// image row and its properties
class image extends StatelessWidget {

  var _product;
  image( product){
    this._product = product;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Center(
        child: Image.network(_product['image'],
          fit: BoxFit.cover,
        )
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
  var _product;

  ProductView( _product){
    this._product = _product;
  }
  @override
  _ProductViewState createState() => _ProductViewState(_product);
}
// scaffold for the whole app level column
class _ProductViewState extends State<ProductView> {

  var _product;
  List<Map<String, String> > _vendors = new List<Map<String, String> >();
  DocumentSnapshot _vendor = null;
  final ProductController _productController = new ProductController();
  bool _loading = true;
  int cartSize = 0;
  final Utils _utils = new Utils();
  DocumentSnapshot _user;

  _ProductViewState(product){
    this._product = product;
  }

  @override
  void initState(){
    super.initState();

    UserController().getUser(this._product['vendorId']).then((user){
      setState(() {
        this._vendor = user;  
        print(this._vendor.data);
      });
    });

    UserController().getCurrentUserDetails().then((user){
      setState((){
        this._user = user;
      });
    });

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
              Navigator.push(context, CupertinoPageRoute(builder: (context) => Search()));
            },
          ),
          CartIcon()
        ],
      ),
      children: <Widget>[
        PageList(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              child: image(_product), 
            ),
            // Divider(),
            ListTile(
              title: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black
                  ),
                  children: [
                    TextSpan(
                      text: _product['price'] != null ? '₹ ' + _product['price'] : '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27
                      )
                    ),
                    // TextSpan(
                    //   text: "   Incl. of all taxes",
                    // )
                  ]
                ),
              ),
              // trailing: RaisedButton(
              //   onPressed: (){

              //   },
              //   color: _utils.colors['theme'],
              //   child: Text(
              //     "ADD",
              //     style: TextStyle(
              //       color: _utils.colors['buttonText'],
              //       fontSize: 15
              //     ),
              //   ),
              // ),
            ),
            ListTile(
              title: Text(_product['name'],
                style: TextStyle(
                  fontSize: 17
                ),
              ),
            ),
            AddButton(_product, null),
            (_user != null && _user.data['vendor'] == 'true') ? Card(
              elevation: 1,
              borderOnForeground: true,
              child: Container(
                height: 50,
                child: Center(
                  child: ListTile(
                    title: Text("Want to add yourself to the list?",
                      style: TextStyle(
                        fontSize: 12
                      ),
                    ),
                    trailing: InkWell(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => AddVendorToProduct(_product['id'], _product['image'], _product['name'])));
                      },
                      child: Chip(
                        backgroundColor: _utils.colors['theme'],
                        label: Text("Add",
                          style: TextStyle(
                            color:_utils.colors['buttonText'],
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ) : Divider(),
            ListTile(
              title: Text(
                "Seller",
                style: TextStyle(
                  color: _utils.colors['theme'],
                  fontSize: 16
                ),
              ),
            ),
            ListTile(
              title: Text(
                this._vendor == null ? "" : this._vendor.data['username'],
                style: TextStyle(
                  fontSize: 14
                ),
              ),
              subtitle: Text(
                this._vendor == null ? "" : this._vendor.data['address'],
                style: TextStyle(
                  fontSize: 14
                ),
              ),
            ),
            ExpansionTile(
              title: Text(
                "More Sellers",
                style: TextStyle(
                  color: _utils.colors['theme'],
                  fontSize: 16
                ),
              ),
              children: _loading ? [
                SpinKitCircle(color: _utils.colors['loading'])
              ] : 
              this._vendors.map((v){
                return listTileItem(v['name'], v['price'], v['address'], v['id']);
              }).toList()
            ),
          ],
        ),
        // _loading ? PageItem(
        //   child:Center(
        //     child: SpinKitCircle(color: _utils.colors['loading']),
        //   )
        // ) : PageList.separated(
        // // shrinkWrap: true,
        // itemCount: _vendors.length,
        // itemBuilder: (context, index) {
          // if (index == 0) {
          //   return ListTile(
          //     title:image(_product),
          //   );
          // }else if(index == 1){
          //   return ListTile(
          //     title: Text(_product['name'],
          //       style: TextStyle(
          //         fontSize: 18
          //       ),
          //     )
          //   );
          // } else if(index == 2){
          //   return Card(
          //     elevation: 0,
          //     child: Container(
          //       height: 50,
          //       child: Center(
          //         child: ListTile(
          //           title: Text("Want to add yourself to the list?"),
          //           trailing: InkWell(
          //             onTap: (){
          //               Navigator.push(context, CupertinoPageRoute(builder: (context) => AddVendorToProduct(_product['id'], _product['image'], _product['name'])));
          //             },
          //             child: Chip(
          //               backgroundColor: _utils.colors['theme'],
          //               label: Text("Add",
          //                 style: TextStyle(
          //                   color:_utils.colors['buttonText'],
          //                   fontWeight: FontWeight.bold
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   );
          // }
          // else {
    //         print('product view loading: ' + _loading.toString());
    //         if(_loading){
    //           return Center(child: SpinKitCircle(color: _utils.colors['loading']));
    //         }else{
    //           return listTileItem(_vendors[index]['name'],_vendors[index]['price'], _vendors[index]['address'], _vendors[index]['id']);
    //         }
    //       // }
    //     },
    //   separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
    //     ),
      ],
    );
  }

  Widget listTileItem(item, price, address, vendorId) {
  return ListTile(
    title: Text(
      item.length > 30 ? item.substring(0, 30) + '...' : item,
      style: TextStyle(fontSize: 16,)
    ),
    subtitle: Text(
      address
    ),
    trailing:Text(
      '₹ ' + price,
      style: TextStyle(fontSize: 16, 
        color: Colors.red.shade500,
        fontWeight: FontWeight.bold
      ),
    ),
          // Padding(
          //     padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          //     child: ButtonTheme(
          //       minWidth: 10,
          //       height: 40,
          //       child: RaisedButton(
          //         onPressed: (){
          //           globals.cart.add(
          //             {
          //               "id" : this._product['id'],
          //               "name" : this._product['name'],
          //               "image" : this._product['image'],
          //               "price" : price,
          //               "vendorName" : item,
          //               "vendorId" : vendorId,
          //             });
          //           print("Cart : ${globals.cart.toString()}");
          //           globals.cartSize += 1;
          //           setState(() {
          //             this.cartSize += 1;
          //           });
          //         },
                  
          //         color: _utils.colors['theme'],
          //         child: Text("Add",
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             color: _utils.colors['buttonText'],
          //             fontWeight: FontWeight.bold,
          //             fontSize: 15,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
  );
}


}
