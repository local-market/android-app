import "package:flutter/material.dart";
import 'package:local_market/components/horizontal_slide.dart';
import 'package:local_market/components/products.dart';
import "package:local_market/controller/user_controller.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:local_market/utils/utils.dart';
import "package:local_market/views/login.dart";
import 'add_product.dart';
import "package:carousel_pro/carousel_pro.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  UserController userController = new UserController();
  final Utils _utils = new Utils();

  @override
  Widget build(BuildContext context) {
    Widget images_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/img/c1.jpg'),
          AssetImage('assets/img/m1.jpeg'),
          AssetImage('assets/img/m2.jpg'),
          AssetImage('assets/img/w1.jpeg'),
          AssetImage('assets/img/w3.jpeg'),
          AssetImage('assets/img/w4.jpeg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        dotColor: Colors.green,
        indicatorBgPadding: 4.0,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Apni dukan'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text("Pankaj Devesh"),
              accountEmail: Text('pankajdevesh3@gmail.com'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      'https://avatars1.githubusercontent.com/u/28962789'),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("Home"),
                leading: Icon(Icons.person, color: Colors.pink),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("My Account"),
                leading: Icon(Icons.shopping_basket, color: Colors.pink),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("My Order"),
                leading: Icon(Icons.dashboard, color: Colors.pink),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("Favourites"),
                leading: Icon(Icons.favorite, color: Colors.pink),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("Settings"),
                leading: Icon(Icons.settings),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("Help"),
                leading: Icon(
                  Icons.help,
                  color: Colors.blue,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                userController.logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: ListTile(
                title: Text("Logout", style: TextStyle(color: Colors.black26),),
                leading: Icon(
                  Icons.warning,
                  color: Colors.yellow,
                ),
              ),
            ),
          ],
        ),
      ),
      body: new ListView(
        children: <Widget>[
          images_carousel,

          // padding
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Products"),
          ),

          // horizintal list view
          HorizontalList(),

          // padding
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("New"),
          ),

          new Container(
            height: 300.0,
            child: Products(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  void check() async {
    if(!(await _utils.isLoggedIn())){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
