import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:local_market/controller/product_controller.dart";

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
  final ProductController _productController = new ProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        elevation: 0.1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: OutlineButton(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.8), width: 1.0),
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
                color: Colors.grey.withOpacity(0.2),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                  child: TextFormField(
                    autofocus: false,
                    controller: _productNameController,
                    decoration: InputDecoration(
                      hintText: "Product Name",
                      border: InputBorder.none
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
                color: Colors.grey.withOpacity(0.2),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                  child: TextFormField(
                    autofocus: false,
                    controller: _productPriceController,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Price",
                      border: InputBorder.none
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
              child: Row(children: <Widget>[
                Checkbox(value: inStock, onChanged: (value){
                  setState(() {
                    inStock = value;
                  });
                }, checkColor: Colors.white, activeColor: Colors.red,),
                Text("In Stock")
              ],)
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Material(
                // borderRadius: BorderRadius.circular(20.0),
                color: Colors.red.withOpacity(0.8),
                elevation: 0.8,
                child: MaterialButton(
                  onPressed: () {
                    validateAndUpload();
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Add Product",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
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
    );
  }

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
        child: Icon(Icons.add, color:Colors.grey),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 80, 14, 80),
        child: Image.file(_productImage, fit: BoxFit.cover, width:200,),
      );
    }
  }

  void validateAndUpload() {
    FormState _formState = _formKey.currentState;
    if(_formState.validate()){
      if(_productImage != null){
        _productController.add(_productImage,{
          "name": _productNameController.text,
          "price": _productPriceController.text,
          "inStock": inStock.toString()
        }).then((value){
          _formState.reset();
          Fluttertoast.showToast(msg: "Product added");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddProduct()));
        }).catchError((e){
          print(e.toString());
        });
      }else{
        Fluttertoast.showToast(msg:"Image must be selected");
      }
    }
  }
}