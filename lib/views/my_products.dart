import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product_list_generator.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_market/views/product_view.dart';
import 'package:local_market/views/update_product.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:local_market/utils/globals.dart' as globals;

class MyProducts extends StatefulWidget {
  String subCategoryId;
  MyProducts(this.subCategoryId);
  @override
  _MyProductsState createState() => _MyProductsState(this.subCategoryId);
}

class _MyProductsState extends State<MyProducts> {
  List<DocumentSnapshot> _products = new List<DocumentSnapshot>();
  final UserController _userController = new UserController();
  final ProductController _productController = new ProductController();
  final Utils _utils = new Utils();
  bool _loading = true;
  String subCategoryId;

  _MyProductsState(this.subCategoryId);

  @override
  void initState(){
    super.initState();
    // check();
    fillProducts();
  }

  void fillProducts() async {
    _loading = true;
    // FirebaseUser user = await _userController.getCurrentUser();
    QuerySnapshot products = await Firestore.instance.collection('users').document(globals.currentUser.data['id']).collection('products').getDocuments();
    for(var i = 0; i < products.documents.length; i++){
      DocumentSnapshot product = await _productController.get(products.documents[i]['id']);
      if(product.data != null && product.data['subCategory'] == this.subCategoryId) {
        setState(() {
          this._products.add(product);
          _loading = false;
        });
      }
    }
//    _userController.getAllProductsBySubCategory(user.uid.toString(), this.subCategoryId).then((products){
//       print(products);
//      setState(() {
//        _products = products;
//        // print(products.toString());
//        // print(_products.toString());
//        _loading = false;
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {

    return Page(
      appBar: RegularAppBar(
        elevation: _utils.elevation,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color:_utils.colors['appBarIcons']
        ),
        title: Text("My Products",
          style: TextStyle(
            color: _utils.colors['appBarText']
          ),
        ),
        backgroundColor: _utils.colors['appBar'],
      ),
      children: <Widget>[
        _loading ? PageItem(child:SpinKitCircle(color: _utils.colors['loading'])) :
        PageList.separated(
            itemCount: this._products.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductView(_products[index])));
                  },
                  leading: Image.network(_products[index]['image'], width: 50,),
                  title: Text(_products[index]['name'].length > 30 ? _products[index]['name'].substring(0, 30) + '...' : _products[index]['name']),
                  trailing: IconButton(
                    onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context) => UpdateProduct(this._products[index]['id'], this._products[index]['name'], this._products[index]['image'])));
              },
                icon: Icon(OMIcons.edit,
                  color: Utils().colors['icons'],),
              ) ,
                ),
              );
            },
            separatorBuilder: (context,index){
              return Divider();
            }
        )
//        ProductListGenerator(_products, true)
      ],
    );
  }

  // void check() async {
  //   if(!(await _utils.isLoggedIn())){
  //     Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login()));
  //   }
  // }
}