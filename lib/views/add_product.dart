import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/category_controller.dart';
import "package:local_market/controller/product_controller.dart";
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'login.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _productNameController = new TextEditingController();
  TextEditingController _productPriceController = new TextEditingController();
  var inStock = true;
  File _productImage = null;
  List<Map<String, String>> _categories = new List<Map<String, String>> ();
  List<Map<String, String>> _subCategories = new List<Map<String, String>> ();
  Map<String, String> _selectedCategory = null;
  Map<String, String> _selectedSubCategory = null;
  final ProductController _productController = new ProductController();
  final CategoryController _categoryController = new CategoryController();
  final Utils _utils = new Utils();
  final UserController userController = new UserController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {

    return Page(
      appBar: RegularAppBar(
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons']
        ),
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        elevation: _utils.elevation,
        title: Text("Add Product",
          style: TextStyle(
            color: _utils.colors['appBarText'],
          ),
        ),
      ),
      children: <Widget>[
        Form(
          key: _formKey,
          child: PageList(
            // shrinkWrap: true,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: OutlineButton(
                        borderSide: BorderSide(color: _utils.colors['icons'].withOpacity(0.8), width: 1.0),
                        onPressed: (){
                          _selectImage(ImagePicker.pickImage(source: ImageSource.gallery));
                        },
                        child: _displayProductImage()
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Material(
                  color: Colors.white.withOpacity(0.2),
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: TextFormField(
                      autofocus: false,
                      controller: _productNameController,
                      decoration: InputDecoration(
                        hintText: "Product Name",
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
                  color: Colors.white.withOpacity(0.2),
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: DropdownButton<Map<String, String>>(
                      isExpanded: true,
                      hint: Text("Category"),
                      items: this._categories.map((Map<String, String> category){
                        return new DropdownMenuItem<Map<String, String>>(
                          value: category,
                          child: Text(category['name'])
                        );
                      }).toList(),
                      onChanged: (value){
                        _categoryController.getSubCategory(value['id']).then((subCategories){
                          setState(() {
                            this._selectedCategory = value;
                            this._subCategories = subCategories;
                          });
                        });
                      },
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Material(
                  color: Colors.white.withOpacity(0.2),
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: DropdownButton<Map<String, String>>(
                      isExpanded: true,
                      hint: Text("Sub Category"),
                      items: this._subCategories.map((Map<String, String> subCategory){
                        return new DropdownMenuItem<Map<String, String>>(
                          value: subCategory,
                          child: Text(subCategory['name'])
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          this._selectedSubCategory = value;
                        });
                      },
                    )
                  ),
                ),
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
                  child: _loading ? CircularLoadingButton() : MaterialButton(
                    onPressed: () {
                      validateAndUpload();
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Add Product",
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
  
  @override
  void initState() {
    super.initState();
    this._categoryController.getAll()
    .then((categories){
      setState(() {
        this._categories = categories;
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

  void _selectImage(Future<File> pickImage) async {
    File temp = await pickImage;
    setState(() {
      _productImage = temp;
    });
  }

  Widget _displayProductImage() {
    if(_productImage == null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 80, 14, 80),
        child: Icon(OMIcons.addAPhoto, color: _utils.colors['icons']),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 80, 14, 80),
        child: Image.file(_productImage, fit: BoxFit.cover, width:200,),
      );
    }
  }

  void validateAndUpload() async {
    // check();
    FormState _formState = _formKey.currentState;
    if(_formState.validate()){
      if(_productImage == null){
        Fluttertoast.showToast(msg:"Image must be selected");
      }else if(this._selectedCategory == null){
        Fluttertoast.showToast(msg:"Category must be selected");
      }else if(this._selectedSubCategory == null){
        Fluttertoast.showToast(msg:"Sub Category must be selected");
      }
      else{
        setState(() {
          _loading = true;
        });
        FirebaseUser currentUser = await userController.getCurrentUser();
        // DocumentSnapshot userDetails = await userController.getUser(currentUser.uid.toString());

        _productController.add(_productImage,_productNameController.text,currentUser.uid.toString(), this._selectedSubCategory['id'],{
          "price": _productPriceController.text,
          "inStock": inStock.toString(),
          // "vendorName": userDetails.data['name'],
          "id": currentUser.uid.toString(),
          // "vendorAddress": userDetails.data['address']
        }).then((value){
          _formState.reset();
          Fluttertoast.showToast(msg: "Product added");
          setState(() {
            _loading = false;
          });
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => AddProduct()));
        }).catchError((e){
          print(e.toString());
        });
      }
    }
  }
}