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
import 'package:local_market/views/my_products_sub_category.dart';

class MyProductsCategory extends StatefulWidget {
  @override
  _MyProductsCategoryState createState() => _MyProductsCategoryState();
}

class _MyProductsCategoryState extends State<MyProductsCategory> {
  List<Map<String, String> > _products = new List<Map<String, String> >();
  final UserController _userController = new UserController();
  final CategoryController _categoryController = new CategoryController();
  final Utils _utils = new Utils();
  List<Map<String, String>>_categories = new List<Map<String,String>>();
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    // check();
    _categoryController.getAll().then((categories){
      setState(() {
        this._categories = categories;
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
            itemCount: this._categories.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => MyProductsSubCategory(this._categories[index]['id'])));
                },
                child: ListTile(
                  title: Text(
                    this._categories[index]['name']
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