import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/horizontal_slide.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/products.dart';
import 'package:local_market/controller/product_controller.dart';
import "package:local_market/controller/user_controller.dart";
import 'package:local_market/utils/utils.dart';
import "package:local_market/views/login.dart";
import 'package:local_market/views/my_products.dart';
import "package:local_market/views/search.dart";
import 'package:local_market/views/user_profile.dart';
import 'add_product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final UserController userController = new UserController();
  final Utils _utils = new Utils();
  final ProductController _productController = new ProductController();
  final UserController _userController = new UserController();
  DocumentSnapshot _user = null;

  Widget getCarousel(){
    return CarouselSlider(
      items: [
        'assets/img/c1.jpg',
        'assets/img/m1.jpeg',
        'assets/img/w1.jpeg',
        'assets/img/w3.jpeg',
        'assets/img/w4.jpeg',
      ].map((image){
        return Builder(
          builder: (BuildContext context){
            return Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(image,
                  fit: BoxFit.cover,
                  // width: MediaQuery.of(context).size.width,
                ),
              )
            );
          }
        );
      }).toList(),
      // height: 300,
      aspectRatio: 16/9,
      enlargeCenterPage: true,
      // viewportFraction: 1.0,
      autoPlay: true,
      reverse: false,
      enableInfiniteScroll: true,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Page(
      appBar: FloatingAppBar(
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.dark,
        elevation: 8,
        title: InkWell(
          onTap: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context) => Search()));
          },
          child: Text("Search for products",
            style: TextStyle(
              color: _utils.colors['appBarText']
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons']
        ),
        actions: <Widget>[
          // new IconButton(
          //     icon: Icon(
          //       Icons.search,
          //       color: _utils.colors['appBarIcons'],
          //     ),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
          //     }),
          new IconButton(
              icon: Icon(
                OMIcons.shoppingCart,
                color: _utils.colors['appBarIcons'],
              ),
              onPressed: null)
        ],
      ),
      children: <Widget>[
        PageList(
          children: <Widget>[
            getCarousel(),

            // padding
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Categories"),
            ),

            // horizintal list view
            HorizontalList(),

            // padding
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("New"),
            ),
          ],
        ),
        Products()
      ],
      drawer: getDrawer(),
    );
  }

  @override
  void initState() {
    super.initState();
    _userController.getCurrentUserDetails().then((user){
      setState(() {
        _user = user;
      });
    });
  }

  Widget getDrawer(){

    List<Widget> children = new List<Widget>();

    children.add(
      UserAccountsDrawerHeader(
        accountName: Text( _user != null ? _user.data['username'] : 'Guest', style: TextStyle(color: _utils.colors['drawerHeaderText']),),
        accountEmail: _user != null ? Text( _user != null ? _user.data['email'] : '', style: TextStyle(color: _utils.colors['drawerHeaderText']),) : InkWell(
          onTap: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context) => Login()));
          },
          child: Text("Login/Signup",
          style: TextStyle(color:_utils.colors['theme']),),
        ),
        currentAccountPicture: GestureDetector(
          child: new CircleAvatar(
            backgroundColor: _utils.colors['theme'],
            child: Text( _user != null ? _user.data['username'][0] : "G",
              style: TextStyle(
                fontSize: 25,
                color: _utils.colors['buttonText']
              ),
            ),
            // backgroundImage: NetworkImage(
            //     'https://avatars1.githubusercontent.com/u/28962789'),
          ),
        ),
        decoration: BoxDecoration(
          color: _utils.colors['drawerHeader'],
        ),
      )
    );

    children.add(Divider());
    children.add(
      InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: ListTile(
          title: Text("Home"),
          leading: Icon(OMIcons.home, color: _utils.colors['drawerIcons']),
        ),
      )
    );

    if(_user != null){
      children.add(
        InkWell(
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => UserProfile()));
          },
          child: ListTile(
            title: Text("My Account"),
            leading: Icon(OMIcons.accountCircle, color: _utils.colors['drawerIcons']),
          ),
        )
      );

      if(_user.data['vendor'] == 'true'){

        children.add(
          InkWell(
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => MyProducts()));
            },
            child: ListTile(
              title: Text("My Products"),
              leading: Icon(OMIcons.shoppingCart, color: _utils.colors['drawerIcons']),
            ),
          )
        );

        children.add(
          InkWell(
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => AddProduct()));
            },
            child: ListTile(
              title: Text("Add Product"),
              leading: Icon(OMIcons.addShoppingCart, color: _utils.colors['drawerIcons']),
            ),
          )
        );

      }
    }

    children.add(
      Divider()
    );

    children.add(
      InkWell(
        onTap: () {},
        child: ListTile(
          title: Text("Settings"),
          leading: Icon(OMIcons.settings,
            color: _utils.colors['drawerIcons'],
          ),
        ),
      )
    );

    children.add(
      InkWell(
        onTap: () {},
        child: ListTile(
          title: Text("Help"),
          leading: Icon(OMIcons.helpOutline,
            color: _utils.colors['drawerIcons'],
          ),
        ),
      )
    );

    if(_user != null){
      children.add(
        InkWell(
          onTap: () {
            userController.logout();
            setState(() {
              _user = null;
            });
          },
          child: ListTile(
            title: Text("Logout"),
            leading: Icon(
              OMIcons.arrowBack,
              color: _utils.colors['drawerIcons'],
            ),
          ),
        )
      );
    }

    return Drawer(
      child: new ListView(
        children: children
      ),
    );
  }
}
