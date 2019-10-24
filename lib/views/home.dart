import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/cart_icon.dart';
import 'package:local_market/components/horizontal_slide.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product.dart';
import 'package:local_market/views/Update_password.dart';
import 'package:local_market/views/contact_us.dart';
import 'package:local_market/views/my_orders.dart';
import 'package:local_market/views/my_products_category.dart';
import 'package:local_market/views/notification.dart';
import 'package:local_market/views/products.dart';
import 'package:local_market/controller/category_controller.dart';
import 'package:local_market/controller/product_controller.dart';
import "package:local_market/controller/user_controller.dart";
import 'package:local_market/utils/utils.dart';
import "package:local_market/views/login.dart";
import 'package:local_market/views/my_products.dart';
import "package:local_market/views/search.dart";
import 'package:local_market/views/sub_categories.dart';
import 'package:local_market/views/user_profile.dart';
import 'add_product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:local_market/utils/globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final UserController userController = new UserController();
  final Utils _utils = new Utils();
  final ProductController _productController = new ProductController();
  final UserController _userController = new UserController();
  final CategoryController _categoryController = new CategoryController();
  DocumentSnapshot _user = null;
  List<List<DocumentSnapshot>> _categoryWithProducts = new List<List<DocumentSnapshot>> ();
  int cartSize = 0;

  Widget getCarousel(){
    return CarouselSlider(
      items: [
        'assets/img/1.jpg',
        'assets/img/2.jpg',
        'assets/img/3.jpg',
        'assets/img/4.jpg',
        'assets/img/5.jpg',
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
    var product_list = [
    {
      "id" : "16295390-cfb8-11e9-e98d-e3d6c3ec2661",
      "name": "nokia 6.1 plus (black, 6gb ram, 64gb storage)",
      "image": "https://firebasestorage.googleapis.com/v0/b/local-market-454fa.appspot.com/o/16295390-cfb8-11e9-e98d-e3d6c3ec2661?alt=media&token=545cece9-e412-494a-a2a5-c9f61397e602",
      "old_price": "100",
      "price": "50",
      "currency":"rupee",
      "vendorId" : "cN5syaFzDlO7x8yO8pK6WV67zrm2"
    },
    {
      "id" : "16295390-cfb8-11e9-e98d-e3d6c3ec2661",
      "name": "nokia 6.1 plus (black, 6gb ram, 64gb storage)",
      "image": "https://firebasestorage.googleapis.com/v0/b/local-market-454fa.appspot.com/o/16295390-cfb8-11e9-e98d-e3d6c3ec2661?alt=media&token=545cece9-e412-494a-a2a5-c9f61397e602",
      "old_price": "100",
      "price": "50",
      "currency":"rupee",
      "vendorId" : "cN5syaFzDlO7x8yO8pK6WV67zrm2"
    },
    {
      "id" : "16295390-cfb8-11e9-e98d-e3d6c3ec2661",
      "name": "nokia 6.1 plus (black, 6gb ram, 64gb storage)",
      "image": "https://firebasestorage.googleapis.com/v0/b/local-market-454fa.appspot.com/o/16295390-cfb8-11e9-e98d-e3d6c3ec2661?alt=media&token=545cece9-e412-494a-a2a5-c9f61397e602",
      "old_price": "100",
      "price": "50",
      "currency":"rupee",
      "vendorId" : "cN5syaFzDlO7x8yO8pK6WV67zrm2"
    },
    {
      "id" : "16295390-cfb8-11e9-e98d-e3d6c3ec2661",
      "name": "nokia 6.1 plus (black, 6gb ram, 64gb storage)",
      "image": "https://firebasestorage.googleapis.com/v0/b/local-market-454fa.appspot.com/o/16295390-cfb8-11e9-e98d-e3d6c3ec2661?alt=media&token=545cece9-e412-494a-a2a5-c9f61397e602",
      "old_price": "100",
      "price": "50",
      "currency":"rupee",
      "vendorId" : "cN5syaFzDlO7x8yO8pK6WV67zrm2"
    },
    {
      "id" : "16295390-cfb8-11e9-e98d-e3d6c3ec2661",
      "name": "nokia 6.1 plus (black, 6gb ram, 64gb storage)",
      "image": "https://firebasestorage.googleapis.com/v0/b/local-market-454fa.appspot.com/o/16295390-cfb8-11e9-e98d-e3d6c3ec2661?alt=media&token=545cece9-e412-494a-a2a5-c9f61397e602",
      "old_price": "100",
      "price": "50",
      "currency":"rupee",
      "vendorId" : "cN5syaFzDlO7x8yO8pK6WV67zrm2"
    }
  ];

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
          
          CartIcon(),
        ],
      ),
      children: <Widget>[
        PageList(
          children: <Widget>[
            getCarousel(),

            // padding
//            new Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text("Categories"),
//            ),

            // horizintal list view
            HorizontalList(),

            // padding
          ],
        ),
        PageList(
          children: this._categoryWithProducts.map((list){
          return horizontalProductList(list);
        }).toList()
        ),
        // SliverToBoxAdapter(
        //   // padding: const EdgeInsets.all(8.0),
        //   child: ListView.builder(
        //        itemCount: product_list.length,
        //        scrollDirection: Axis.horizontal,
        //         // gridDelegate:
        //       // SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6),
        //       itemBuilder: (context, i){
        //         return Product(product_list[i]);
        //       }
        //     ),
        // ),
        // Products()
      ],
      drawer: getDrawer(),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getProduct();
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
            Navigator.push(context, CupertinoPageRoute(builder: (context) => Login(null)));
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

      if(this._user.data['vendor'] == "false") {
        children.add(
            InkWell(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => MyOrders()));
              },
              child: ListTile(
                title: Text("My Orders"),
                leading: Icon(OMIcons.addShoppingCart,
                    color: _utils.colors['drawerIcons']),
              ),
            )
        );
      }

      children.add(
        InkWell(
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => ChangePassword()));
          },
          child: ListTile(
            title: Text("Change Password"),
            leading: Icon(OMIcons.adjust, color: _utils.colors['drawerIcons']),
          ),
          )

      );



      if(_user.data['vendor'] == 'true'){

        children.add(
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductRequests()));
              },
              child: ListTile(
                title: Text("Notification"),
                leading: Icon(OMIcons.notifications, color: _utils.colors['drawerIcons']),
              ),
            )
        );

        children.add(
          InkWell(
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => MyProductsCategory()));
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
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => ContactUs()));
        },
        child: ListTile(
          title: Text("Contact Us"),
          leading: Icon(OMIcons.contactMail,
            color: _utils.colors['drawerIcons'],
          ),
        ),
      )
    );

    // children.add(
    //   InkWell(
    //     onTap: () {},
    //     child: ListTile(
    //       title: Text("Help"),
    //       leading: Icon(OMIcons.helpOutline,
    //         color: _utils.colors['drawerIcons'],
    //       ),
    //     ),
    //   )
    // );

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

  Future<void> getProduct() async {
    List<Map<String, String>> categories = await _categoryController.getAll();
    // manually did that
//    _productController.getNBySubCategory('mobile-Whw9eENMAsH4bsAAROfz', 6).then((mobiles){
//      if(mobiles.length > 0){
//        mobiles[0].data['categoryName'] = 'Mobiles';
//        setState(() {
//          this._categoryWithProducts.add(mobiles);
//        });
//      }
//    });

    for(var i = 0; i < categories.length; i++){
      List<DocumentSnapshot> products = await _productController.getNByCategory(categories[i]['id'], 6);
      if(products.length > 0){
        products[0].data['categoryName'] = categories[i]['name'];
        setState(() {
          this._categoryWithProducts.add(products);
        });
        // print(products[0].data.toString());
      }
    }
  }

  Widget horizontalProductList(List<DocumentSnapshot> product_list){
    return Container(
      height: 318,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Container(
              height: 500,
              color: Colors.grey.shade100,
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(product_list[0].data['categoryName'],
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                trailing: Chip(
                  backgroundColor: _utils.colors['theme'],
                  label: InkWell(
                    onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => SubCategories(product_list[0].data['category'])));
                    },
                    child: Text(
                      "View all",
                      style: TextStyle(
                        color: _utils.colors['buttonText'],
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  ),
                )
              ),
              Container(
                height: 258,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: product_list.length + 1,
                  itemBuilder: (context, i){
                    if(i == product_list.length) {
                      // print(i);
                      return Product(product_list[i - 1].data, false, true);
                    }
                    else return Product(product_list[i].data, false, false);
                  },
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
