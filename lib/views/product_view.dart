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
import 'package:local_market/views/image_preview.dart';
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
      child: InkWell(
        onTap: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => ImagePreview(this._product['image'])));
        },
        child: Center(
          child: Image.network(_product['image'],
            fit: BoxFit.cover,
          )
        ),
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
  // DocumentSnapshot _user;
  String _productDescription = '';
  String _selectedSize = null;
  List<dynamic> size = new List<String>();

  _ProductViewState(product){
    this._product = product;
  }

  void updateSize(String vendorId, String productId) async {
    List<dynamic> size = await _productController.getVendorSize(productId, vendorId);
    setState(() {
      this.size = size;
      print(this.size);
    });
  }

  @override
  void initState(){
    super.initState();

    updateSize(this._product['vendorId'], this._product['id']);

    UserController().getUser(this._product['vendorId']).then((user){
      setState(() {
        this._vendor = user;  
        print(this._vendor.data);
      });
    });

    // UserController().getCurrentUserDetails().then((user){
    //   setState((){
    //     this._user = user;
    //   });
    // });

    _productController.getVendors(_product['id']).then((value){
      setState(() {
        this._vendors = value;
        _loading = false;
        // print("vendors details : " + value.toString());
      });
    });
    
    var descriptionSplit = this._product['description'].split('\\n');
    print(descriptionSplit);
    if(descriptionSplit.length == 1){
      descriptionSplit = this._product['description'].split('/n');
    }
    // this._product['description'] = '';
    for(var i = 0; i < descriptionSplit.length; i++){
      setState((){
        this._productDescription += descriptionSplit[i] + '\n';
      });
      print(this._productDescription);
    }
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
      bottomNavigationBar: Container(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ((globals.currentUser != null && globals.currentUser.data['vendor'] == 'true') || (this.size != null && this.size.length > 0 && this._selectedSize == null)) ?
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0),
              child: ButtonTheme(
                  minWidth: double.infinity,
                  child: RaisedButton(
                    onPressed: (){},

                    color: Colors.grey.shade500,
                    child: Text(
                      "Local Market!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _utils.colors['buttonText'],
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  )
              )
          ) : AddButton(_product, null, this._selectedSize, true),
        ),
      ),
      children: <Widget>[
        PageList(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 200,
                  child: image(_product),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 12, 0,0),
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
            ),
            ListTile(
              title: Text(_utils.titleCase( _product['name']),
                style: TextStyle(
                    fontSize: 16
                ),
              ),
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
                      text: _product['offerPrice'] != null ? '₹ ' + _product['offerPrice']+ '  ' : '',
                      style: TextStyle(
                        color: _utils.colors['theme'],
                        fontSize: 27
                      )
                    ),
                    TextSpan(
                      text: '₹ ${_product['price']}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade700,
                        decoration: TextDecoration.lineThrough
                      )
                    )
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
            this.size != null && this.size.length > 0 ? Padding (
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Material(
                  color: Colors.white.withOpacity(0.2),
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text(
                        this._selectedSize == null ? "Size" : this._selectedSize
                      ),
                      items: this.size.map((s){
                        return new DropdownMenuItem<String>(
                          value: s,
                          child: Text(s)
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          this._selectedSize = value;
                        });
                      },
                    )
                  ),
                ),
              ) : Container()
              ,
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 0, 14.0, 4),
              child: Text("Description:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 0, 14.0, 0),
              child: Text(this._productDescription),
            ),
            (globals.currentUser != null && globals.currentUser.data['vendor'] == 'true') ? Card(
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
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => AddVendorToProduct(_product['id'], _product['image'], _product['name'], _product['subCategory'])));
                      },
                      child: Chip(
                        backgroundColor: _utils.colors['theme'],
                        label: Text("Add/Update product",
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
              leading: Text(
                "Sold by :",
                style: TextStyle(
                  color: _utils.colors['theme'],
                  fontSize: 12
                ),
              ),
              trailing: Text(
              this._vendor == null ? "" : this._vendor.data['username'],
                style: TextStyle(
                  fontSize: 12
                ),
              ),
            ),
            Divider(),
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
                return listTileItem(v['name'], v['price'], v['offerPrice'], v['address'], v['id'], v['inStock']);
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

  Widget listTileItem(item, price, offerPrice, address, vendorId, stock) {
  return InkWell(
    onTap: (){
      setState((){
        this._product['price'] = price;
        this._product['offerPrice'] = offerPrice;
        this._product['vendorId'] = vendorId;
      });
      UserController().getUser(this._product['vendorId']).then((user){
        setState(() {
          this._vendor = user;
        });
      });
    },
    child: ListTile(
      title: Text(
        item.length > 30 ? item.substring(0, 30) + '...' : item,
        style: TextStyle(fontSize: 16,)
      ),
      subtitle: Text(
        address
      ),
      trailing: Column(
        children:[
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                    text: '₹ ${offerPrice}',
                    style: stock.toString() == "false" ?
                        TextStyle(
                          color:Colors.grey.shade700,
                          decoration: TextDecoration.lineThrough
                        )
                    :TextStyle(fontSize: 16,
                        color: _utils.colors['theme'],
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  // TextSpan(
                  //   text: ' ₹ ${offerPrice}',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.grey.shade700,
                  //     decoration: TextDecoration.lineThrough
                  //   )
                  // )
                ]
            ),
          ),
          Text(
            stock.toString() == "false" ? "*Out of stock" : "",
            style: TextStyle(
              color:Colors.red,
              fontSize: 12
            ),
          )
        ]
      )
      // Text(
      //   '₹ ' + price,
      //   style: TextStyle(fontSize: 16, 
      //     color: Colors.red.shade500,
      //     fontWeight: FontWeight.bold
      //   ),
      // ),
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
    ),
  );
}


}
