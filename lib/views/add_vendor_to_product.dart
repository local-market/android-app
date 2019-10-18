import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
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

import 'login.dart';

class AddVendorToProduct extends StatefulWidget {

  String _productId;
  String _productImageUrl;
  String _productName;
  String _subCategory;

  AddVendorToProduct(this._productId, this._productImageUrl, this._productName, this._subCategory);

  @override
  _AddVendorToProductState createState() => _AddVendorToProductState(this._productId, this._productImageUrl, this._productName, this._subCategory);
}

class _AddVendorToProductState extends State<AddVendorToProduct> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final Utils _utils = new Utils();
  final UserController _userController = new UserController();
  final ProductController _productController = new ProductController();
  final SizeController _sizeController = new SizeController();
  TextEditingController _productPriceController = new TextEditingController();
  TextEditingController _productOfferPriceController = new TextEditingController();
  String _productId, _productImageUrl, _productName, _subCategory;
  bool inStock = true;
  bool _pageLoading = false;
  bool _buttonLoading = false;
  Map<String, bool> size = new Map<String, bool> ();
  List<String> sizeKeys = new List<String>();
  
  _AddVendorToProductState(this._productId, this._productImageUrl, this._productName, this._subCategory);

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
          "Add Yourself",
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
                      validateAndAdd();
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Add",
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

  Future<void> validateAndAdd() async {
    FormState _formState = _formKey.currentState;
    if(this.sizeKeys.length > 0){
      if(this.getSelectedSize().length == 0){
        Fluttertoast.showToast(msg: "Size must be selected");
        return;
      }
    }
    if(_formState.validate()){
      setState(() {
        _buttonLoading = true;
      });
      FirebaseUser _currentUser = await _userController.getCurrentUser();
      await _productController.updatePrice(_productId, _currentUser.uid.toString(), {
        "id" : _currentUser.uid.toString(),
        "price" : _productPriceController.text,
        "offerPrice": _productOfferPriceController.text,
        "inStock" : inStock.toString(),
        "size" : this.getSelectedSize()
      }).then((value){
        Navigator.pop(context);
      }).catchError((e){
        setState((){
          _buttonLoading =false;
        });
        print("Add Vendor To Product: " + e.toString());
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    this._sizeController.get(this._subCategory).then((size){
      setState(() {
        this.size = size;
        this.sizeKeys = size.keys.toList();
      });
    });
    // check();
  }

  // void check() async {
  //   DocumentSnapshot _user = await UserController().getCurrentUserDetails();
  //   if((_user == null) || (_user != null && _user['vendor'] == 'false')){
  //     Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login()));
  //   }
  // }
}