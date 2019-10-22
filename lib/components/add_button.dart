import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/globals.dart' as globals;
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/product_view.dart';

class AddButton extends StatefulWidget {
  
  var _product;
  
  Function() _updateTotal;
  String _size;
  bool _inner;
  AddButton(product, @required updateTotal, size, inner){
    this._product = product;
    this._updateTotal = updateTotal;
    this._size = size;
    this._inner = inner;
  }

  @override
  _AddButtonState createState() => _AddButtonState(this._product, this._updateTotal, this._size, this._inner);
}

class _AddButtonState extends State<AddButton> {

  int count = 0;
  var _product;
  var _vendor;
  String _size;
  Function() _updateTotal;
  final Utils _utils = new Utils();
  DocumentSnapshot user = null;
  bool _inner;

  _AddButtonState(this._product, this._updateTotal, this._size, this._inner);

  void clearCount(){
    setState(() {
      this.count = 0;
    });
  }

  void updateCount(){
    setState((){
      if(globals.cart.containsKey(this._product['id'])){
        this.count = int.parse(globals.cart[this._product['id']]['count']);
      }else{
        this.count = 0;
      }
    });
  }

  void updateAllProductCount(String productId){
    if(globals.productListener.containsKey(productId)){
      for(var i = 0; i < globals.productListener[productId].length; i++){
        print(globals.productListener[productId][i].toString());
        try {
          globals.productListener[productId][i]();
        }
        catch(e){
          continue;
          print(e.toString());
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print(this._product['id']);

    UserController().getCurrentUserDetails().then((user){
      setState(() {
        this.user = user;
      });
    });

    ProductController().getVendor(this._product['id'], this._product['vendorId']).then((vendor){
      setState((){
        this._vendor = vendor;
        print(this._vendor);
      });
    });
    

    
    if(globals.cart.containsKey(this._product['id'])){
      setState(() {
        this.count = int.parse(globals.cart[this._product['id']]['count']);
      });
    }

    if(globals.productListener.containsKey(this._product['id'])){
      globals.productListener[this._product['id']].add(this.updateCount);
    }else{
      globals.productListener[this._product['id']] = new List<dynamic>();
      globals.productListener[this._product['id']].add(this.updateCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.count == 0 ? 
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0),
        child: ButtonTheme(
          minWidth: double.infinity,
          child: (this.user != null && this.user.data['vendor'] == "true") ?
          Container() :
          /*this._vendor['inStock'].toString() == 'true' ? */RaisedButton(
            onPressed: (){
              if(this._inner == false) {
                if (_product['category'] ==
                    "computer&mobiles-HJvNLhq9hOTzwOjAsYM4" ||
                    _product['category'] ==
                        "electronics-8oOsgXlOy4MyVUMsgk3q" ||
                    _product['category'] == "men'sFashion" ||
                    _product['category'] ==
                        "women'sFashion-UglnbJHAXwnTpybV5G2a") {
                  Navigator.push(context, CupertinoPageRoute(
                      builder: (context) => ProductView(_product)));
                  return;
                }
              }

              globals.cart[this._product['id']] = {
                  "data" : this._product,
                  "count" : "1",
                  "size" : this._size,
                  "clearCount": this.clearCount
              };
              globals.cartSize += 1;
              print(globals.cart.toString());
              globals.total += double.parse(this._product['offerPrice']);
              setState(() {
                this.count += 1;
              });
              if(this._updateTotal != null){
                this._updateTotal();
              }

              updateAllProductCount(this._product['id']);
            },
            
            color: _utils.colors['theme'],
            child: Text(
              "ADD",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _utils.colors['buttonText'],
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ) /*: RaisedButton(
            child: Text(
              "Out of stock",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500
              )
            ),
            onPressed: (){},
          )*/        
        )
      ) : 
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 0),
        trailing: ButtonTheme(
          minWidth: 5,
          // height: 30,
          // padding: EdgeInsets.all(0),
          child: RaisedButton(
            // padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            color: _utils.colors['theme'],
            child:Text(
              '+',
              style: TextStyle(
                fontSize:13,
                color: _utils.colors['buttonText']
              ),
            ),
            onPressed : (){
              if(this.count < 5){
                setState(() {
                  this.count += 1;
                  globals.cart[this._product['id']]['count'] = this.count.toString();
                  globals.cartSize += 1;
                  globals.total += double.parse(this._product['offerPrice']);
                });
                print(globals.cart.toString());
                if(this._updateTotal != null){
                  this._updateTotal();
                }

                updateAllProductCount(this._product['id']);
              }else{
                Fluttertoast.showToast(msg: "You can't add more than 5 of this items");
              }
            }
          ),
        ),
        title: Center(
          child: Text(
            this.count.toString(),
            style: TextStyle(
              fontSize: 13
            ),
          ),
        ),
        leading: ButtonTheme(
          minWidth: 5,
          // height: 10,
          child: RaisedButton(
            color: _utils.colors['theme'],
            child:Text(
              '-',
              style: TextStyle(
                fontSize: 13,
                color: _utils.colors['buttonText']
              ),
            ),
            onPressed: (){
              if(this.count > 0){
                setState(() {
                  this.count -= 1;
                  globals.cart[this._product['id']]['count'] = this.count.toString();
                  if(this.count == 0){
                    globals.cart[this._product['id']]['clearCount']();
                    globals.cart.remove(this._product['id']);
                    this.count = 0;
                  }
                  globals.cartSize -= 1;
                  globals.total -= double.parse(this._product['offerPrice']);
                });
                print(globals.cart.toString());
                if(this._updateTotal != null){
                  this._updateTotal();
                }

                updateAllProductCount(this._product['id']);
              }
            },
          ),
        ),
      );
  }
}