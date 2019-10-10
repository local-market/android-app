import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/category_controller.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/product_view.dart';

class Products extends StatefulWidget {
  String _tagId;
  String _subCategoryId;
  String _categoryId;

  Products(String tagId, String subCategoryId, String categoryId){
    this._tagId = tagId;
    this._subCategoryId = subCategoryId;
    this._categoryId = categoryId;
  }

  @override
  _ProductsState createState() => _ProductsState(this._tagId, this._subCategoryId, this._categoryId);
}

class _ProductsState extends State<Products> {

  final Utils _utils = new Utils();
  final ProductController _productController = new ProductController();
  final CategoryController _categoryController = new CategoryController();
  List<Map<String, String>> _tags = new List<Map<String, String>>();
  String _tagId;
  String _subCategoryId;
  String _categoryId;
  _ProductsState(this._tagId, this._subCategoryId, this._categoryId);
  bool _loading = true;

  List<DocumentSnapshot> _products = null;

  @override
  void initState() {
    super.initState();
    _categoryController.getTag(this._categoryId, this._subCategoryId).then((tags){
      setState(() {
        this._tags = tags;
      });
    });
    _productController.getByTag(this._tagId).then((products){
      setState(() {
        this._products = products;
        this._loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: RegularAppBar(
        backgroundColor: _utils.colors['appBar'],
        elevation: _utils.elevation,
        iconTheme: IconThemeData(color: _utils.colors['appBarIcons']),
        brightness: Brightness.light,
      ),
      children: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverToBoxAdapter(
            child: Container(
              height: 50,
              child: generateTagHorizontalScroll(this._tags),
            ),
          ),
        ),
        this._loading ? PageItem(child:SpinKitCircle(color: _utils.colors['loading'])) : PageGrid.builder(
          itemCount: this._products == null ? 0 : this._products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, i){
            return Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductView({
                    "id" : this._products[i].data['id'],
                    "name" : this._products[i].data['name'],
                    "image" : this._products[i].data['image']
                  })));
                },
                child: Card(
                  child: GridTile(
                    child: Image.network(this._products[i].data['image'],
                    fit: BoxFit.cover,
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(this._products[i].data['name'],
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  )
                ),
              )
            );
          }
        )
      ],
    );
  }

  Widget generateTagHorizontalScroll(List<Map<String, String>> tags){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tags.length,
      itemBuilder: (context, i){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Chip(
            backgroundColor: _utils.colors['theme'],
            label: InkWell(
              onTap: (){
                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Products(tags[i]['id'], this._subCategoryId, this._categoryId)));
              },
              child: Text(
                tags[i]['name'],
                style: TextStyle(
                  color: _utils.colors['buttonText'],
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}