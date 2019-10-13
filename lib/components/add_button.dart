import 'package:flutter/material.dart';
import 'package:local_market/utils/globals.dart' as globals;
import 'package:local_market/utils/utils.dart';

class AddButton extends StatefulWidget {
  
  var _product;
  Function() _updateTotal;
  AddButton(product, @required updateTotal){
    this._product = product;
    this._updateTotal = updateTotal;
  }

  @override
  _AddButtonState createState() => _AddButtonState(this._product, this._updateTotal);
}

class _AddButtonState extends State<AddButton> {

  int count = 0;
  var _product;
  Function() _updateTotal;
  final Utils _utils = new Utils();

  _AddButtonState(this._product, this._updateTotal);

  void clearCount(){
    setState(() {
      this.count = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    print(this._product['id']);
    if(globals.cart.containsKey(this._product['id'])){
      setState(() {
        this.count = int.parse(globals.cart[this._product['id']]['count']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.count == 0 ? 
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0),
        child: ButtonTheme(
          minWidth: double.infinity,
          child: RaisedButton(
            onPressed: (){
              globals.cart[this._product['id']] = {
                  "data" : this._product,
                  "count" : "1",
                  "clearCount": this.clearCount
              };
              globals.cartSize += 1;
              print(globals.cart.toString());
              globals.total += double.parse(this._product['price']);
              setState(() {
                this.count += 1;
              });
              if(this._updateTotal != null){
                this._updateTotal();
              }
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
          )                
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
              setState(() {
                this.count += 1;
                globals.cart[this._product['id']]['count'] = this.count.toString();
                globals.cartSize += 1;
                globals.total += double.parse(this._product['price']);
              });
              print(globals.cart.toString());
              if(this._updateTotal != null){
                this._updateTotal();
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
              setState(() {
                this.count -= 1;
                globals.cart[this._product['id']]['count'] = this.count.toString();
                if(this.count == 0){
                  globals.cart[this._product['id']]['clearCount']();
                  globals.cart.remove(this._product['id']);
                  this.count = 0;
                }
                if(globals.cartSize > 0){
                  globals.cartSize -= 1;
                  globals.total -= double.parse(this._product['price']);
                }
              });
              print(globals.cart.toString());
              if(this._updateTotal != null){
                this._updateTotal();
              }
            },
          ),
        ),
      );
  }
}