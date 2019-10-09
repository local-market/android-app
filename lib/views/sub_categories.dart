import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/category_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/products.dart';

class SubCategories extends StatefulWidget {
  String _categoryId;

  SubCategories(String categoryId){
    this._categoryId = categoryId;
  }

  @override
  _SubCategoriesState createState() => _SubCategoriesState(this._categoryId);
}

class _SubCategoriesState extends State<SubCategories> {

  final CategoryController _categoryController = new CategoryController();
  final Utils _utils = new Utils();
  String _categoryId;
  bool _loading = true;
  List<Map<String, String>> _subCategories = null;
  _SubCategoriesState(this._categoryId);

  @override
  void initState() {
    super.initState();
    _categoryController.getSubCategory(this._categoryId)
    .then((subCategories){
      setState(() {
        this._subCategories = subCategories;
        this._loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Page (
      appBar: RegularAppBar(
        backgroundColor: _utils.colors['appBar'],
        elevation: _utils.elevation,
        iconTheme: IconThemeData(color: _utils.colors['appBarIcons']),
        brightness: Brightness.light,
      ),
      children: <Widget>[
        this._loading ? PageItem(child:SpinKitCircle(color: _utils.colors['loading'])) : PageGrid.builder(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2),
          itemCount: this._subCategories != null ? this._subCategories.length : 0,
          itemBuilder: (context, i){
            return (
              Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => Products(this._subCategories[i]['id'])));
                  },
                  child: Card(
                    child: Center(
                      child: ListTile(
                        leading: Image.asset('assets/cats/dress.png'),
                        title : Text(this._subCategories[i]['name'])
                      ),
                    ),
                  ),
                )
              )
            );
          }
        )
      ],
    );
  }
}