import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product_list_generator.dart';
import 'package:local_market/controller/category_controller.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/my_products.dart';

class MyProductsSubCategory extends StatefulWidget {
  String categoryId;
  MyProductsSubCategory(this.categoryId);
  @override
  _MyProductsSubCategoryState createState() => _MyProductsSubCategoryState(this.categoryId);
}

class _MyProductsSubCategoryState extends State<MyProductsSubCategory> {
  List<Map<String, String> > _products = new List<Map<String, String> >();
  final UserController _userController = new UserController();
  final CategoryController _categoryController = new CategoryController();
  final Utils _utils = new Utils();
  List<Map<String, String>>_subCategories = new List<Map<String,String>>();
  bool _loading = true;
  String _categoryId;

  _MyProductsSubCategoryState(this._categoryId);

  @override
  void initState(){
    super.initState();
    // check();
    _categoryController..getSubCategory(this._categoryId).then((subCategories){
      setState(() {
        this._subCategories = subCategories;
        this._loading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return Page(
      appBar: RegularAppBar(
        elevation: _utils.elevation,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
            color:_utils.colors['appBarIcons']
        ),
        title: Text("My Products",
          style: TextStyle(
              color: _utils.colors['appBarText']
          ),
        ),
        backgroundColor: _utils.colors['appBar'],
      ),
      children: <Widget>[
        _loading ? PageItem(child:SpinKitCircle(color: _utils.colors['loading'])) :
        PageList.separated(
            itemCount: this._subCategories.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => MyProducts(this._subCategories[index]['id'])));
                },
                child: ListTile(
                  title: Text(
                      this._subCategories[index]['name']
                  ),
                ),
              );
            },
            separatorBuilder: (context, index){
              return Divider();
            }
        )
      ],
    );
  }

// void check() async {
//   if(!(await _utils.isLoggedIn())){
//     Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login()));
//   }
// }
}