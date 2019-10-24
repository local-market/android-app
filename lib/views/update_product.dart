import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/controller/size_controller.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/utils/globals.dart' as globals;

import 'login.dart';

class UpdateProduct extends StatefulWidget {
  String _id, _name, _imageUrl;

  UpdateProduct(String id, String name, String imageUrl){
    this._id = id;
    this._name = name;
    this._imageUrl = imageUrl;
  }

  @override
  _UpdateProductState createState() => _UpdateProductState(this._id, this._name, this._imageUrl);
}

class _UpdateProductState extends State<UpdateProduct> {
  String _productId;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _productPriceController = new TextEditingController();
  TextEditingController _productOfferPriceController = new TextEditingController();
  final ProductController _productController = new ProductController();
  final UserController _userController = new UserController();
  final Utils _utils = new Utils();
  final SizeController _sizeController = new SizeController();
  String _productImageUrl, _productName;
  bool inStock = true;
  bool _pageLoading = true;
  bool _buttonLoading = false;
  Map<String, bool> size = new Map<String, bool> ();
  List<String> sizeKeys = new List<String>();

  _UpdateProductState(String id, String name, String imageUrl){
    this._productId = id;
    this._productName = name;
    this._productImageUrl = imageUrl;
  }

  @override
  void initState(){
    super.initState();
    // check();
    _productController.get(this._productId).then((product){
      _sizeController.get(product.data['subCategory']).then((size){
        setState((){
          this.size = size;
          this.sizeKeys = size.keys.toList();
        });
      });
    });

    // _userController.getCurrentUser().then((user){
      _productController.getPrice(_productId, globals.currentUser.data['id']).then((product){
        setState(() {
          _productPriceController.text = product.data['price'];
          _productOfferPriceController.text = product.data['offerPrice'];
          if(product.data['inStock'] == "true"){
            print(product.data['inStock']);
            inStock = true;
          }else{
            print(product.data['inStock']);
            inStock = false;
          }
          if(product.data['size'] != null && product.data['size'].length > 0){
            for(var i = 0; i < product.data['size'].length; i++){
              this.size[product.data['size'][i]] = true;
            }
          }
          _pageLoading = false;
        });
      });
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Page(
      appBar: RegularAppBar(
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons']
        ),
        title: Text(
          "Update Product",
          style: TextStyle(
            color: _utils.colors['appBarText']
          ),
        ),
        elevation: _utils.elevation,
      ),
      children: <Widget>[
        _pageLoading ? PageItem(child:SpinKitCircle(color: _utils.colors['loading'])) : Form(
          key: _formKey,
          child: PageList(
            // shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Center(
                  child: Image.network(_productImageUrl, width:200)
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Material(
                  // color: _utils.colors['textFieldBackground'].withOpacity(0.2),
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: Text(_productName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Material(
                  color: _utils.colors['textFieldBackground'].withOpacity(0.2),
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: TextFormField(
                      autofocus: false,
                      controller: _productPriceController,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Price",
                        // border: InputBorder.none
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return "This field cannot be empty";
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Material(
                  color: _utils.colors['textFieldBackground'].withOpacity(0.2),
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: TextFormField(
                      autofocus: false,
                      controller: _productOfferPriceController,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Offer Price",
                        // border: InputBorder.none
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return "This field cannot be empty";
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: this.generateSizeView(this.sizeKeys)
                ,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: Row(children: <Widget>[
                  Checkbox(value: inStock, onChanged: (value){
                    setState(() {
                      inStock = value;
                    });
                  }, checkColor: Colors.white, activeColor: _utils.colors['theme'],),
                  Text("In Stock")
                ],)
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 8, 20, 8),
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  color: _utils.colors['theme'],
                  // elevation: _utils.elevation,
                  child: _buttonLoading ? CircularLoadingButton() : MaterialButton(
                    onPressed: () {
                      validateAndUpdate();
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Update Product",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _utils.colors['buttonText'],
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> generateSizeView(List<String> size){
    List<Widget> results = new List<Widget>();
    int n = (size.length / 5).ceil();
    for(var i = 0 ; i < n; i++){
      List<Widget> temp = new List<Widget>();
      for(var j = i * 5; j < (i * 4) + 5 && j < size.length; j++){
        temp.add(
          Row(
            children: <Widget>[
              Checkbox(value: this.size[size[j]], onChanged: (value){
              setState(() {
                this.size[size[j]] = value;
              });
            }, checkColor: Colors.white, activeColor: _utils.colors['theme'],),
            Text(size[j])
            ],
          )
        );
      }
      results.add(
        Row(
          children: temp,
        )
      );
    }
    return results;
  }

  List<String> getSelectedSize(){
    List<String> results = new List<String>();
    for(var i = 0; i < this.sizeKeys.length; i++){
      if(this.size[this.sizeKeys[i]]){
        results.add(this.sizeKeys[i]);
      }
    }
    return results;
  }
  
  // void check() async {
  //   if(!(await _utils.isLoggedIn())){
  //     Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login()));
  //   }
  // }

  Future<void> validateAndUpdate() async {
    // check();
    FormState _formState = _formKey.currentState;
    if(this.sizeKeys.length > 0){
      if(this.getSelectedSize().length ==0){
        Fluttertoast.showToast(msg: "Size must be selected");
        return ;
      }
    }
    if(_formState.validate()){
      setState(() {
        _buttonLoading = true;
      });
      // FirebaseUser user = await _userController.getCurrentUser();
      _productController.updatePrice(_productId, globals.currentUser.data['id'], {
        "id" : globals.currentUser.data['id'],
        "price" : _productPriceController.text,
        "offerPrice" : _productOfferPriceController.text,
        "inStock" : inStock.toString(),
        "size" : this.getSelectedSize()
      }).then((value){
        _formState.reset();
        Fluttertoast.showToast(msg: "Product updated");
        setState(() {
          _buttonLoading = false;
        });
        Navigator.pop(context);
      }).catchError((e){
        setState(() {
          _buttonLoading = false;
        });
        print(e.toString());
      });
    }
  }
}