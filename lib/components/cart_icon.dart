import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/cart.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class CartIcon extends StatelessWidget {
  int cartSize = 0;

  CartIcon(this.cartSize);

  final Utils _utils = new Utils();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context) => Cart()));
      },
        child: Stack(

          children: <Widget>[
            new IconButton(icon: new Icon(OMIcons.shoppingCart,
              color: _utils.colors['appBarIcons'],),
                onPressed: (){
                  
                },
            ),
            cartSize == 0 ? new Container() :
            new Positioned(
              left: 23,
              top: 4,
              child: new Stack(
                children: <Widget>[
                  Transform(
                    transform: new Matrix4.identity()..scale(0.5),
                    child: new Chip(
                      backgroundColor: _utils.colors['theme'],
                      label: new Text(
                        cartSize.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  )
                ],
              )
            )
          ]
        ),
    );
  }
}