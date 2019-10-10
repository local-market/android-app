import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product.dart';
import 'package:local_market/controller/category_controller.dart';
import 'package:local_market/controller/product_controller.dart';
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
  final ProductController _productController = new ProductController();
  final Utils _utils = new Utils();
  String _categoryId;
  bool _loading = true;
  List<List<Map<String, String>>> _subCategoriesWithProduct = new List<List<Map<String, String>>> ();
  _SubCategoriesState(this._categoryId);

  @override
  void initState() {
    super.initState();
    getProduct().then((products){
      print("Products " + products.toString());
      setState(() {
        this._subCategoriesWithProduct = products;
        this._loading = false;
      });
    });
  }

  Future<List<List<Map<String, String>>>> getProduct() async{
    List<List<Map<String, String>>> results = new List<List<Map<String, String>>>();
    List<Map<String, String>> subCategories = await _categoryController.getSubCategory(this._categoryId);
        // print(subCategories.toString());
        for(var i = 0; i < subCategories.length; i++){
          print(subCategories[i]);
          List<Map<String, String>> products = new List<Map<String, String>> ();
          List<Map<String, String>> tags = await _categoryController.getTag(this._categoryId, subCategories[i]['id']);
            // print(tags.toString());
            for(int j = 0; j < tags.length; j++){
              List<DocumentSnapshot> product = await _productController.getNByTag(tags[j]['id'], 1);
                print(tags[j]['id']);
                print(product);
                if(product.length > 0){
                  products.add({
                    "tag": tags[j]['name'],
                    "tagId" : tags[j]['id'],
                    "subCategoryId": subCategories[i]['id'],
                    "id" : product[0].data['id'],
                    "name" : product[0].data['name'],
                    "price" : "100",
                    "image": product[0].data['image']
                  });
                }
            }
          if(products.length > 0){
            // setState(() {
              results.add(products);
              print(this._subCategoriesWithProduct);
              // _loading = false;
            // });
          }
        }
    return results;
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
      children: this._subCategoriesWithProduct.map((list){
        return horizontalProductList(list);
      }).toList()
      // children: <Widget>[
      //   this._loading ? PageItem(child:SpinKitCircle(color: _utils.colors['loading'])) : horizontalProductList(this._subCategoriesWithProduct[0])
            
      // ],
    );
  }


  Widget horizontalProductList(List<Map<String, String>> product_list){
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 470,
          
          child: Stack(
            children: <Widget>[
              Container(
                height: 600,
                color: Colors.grey.shade100,
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: Text(product_list[0]['tag'],
                      style: TextStyle(
                        fontSize: 23
                      ),
                    ),
                    trailing: Chip(
                      backgroundColor: _utils.colors['theme'],
                      label: InkWell(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => Products(product_list[0]['tagId'], product_list[0]['subCategoryId'] ,this._categoryId)));
                        },
                        child: Text(
                          "View all",
                          style: TextStyle(
                            color: _utils.colors['buttonText'],
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                  ),
                  Container(
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: product_list.length,
                      itemBuilder: (context, i){
                        return Product(product_list[i]);
                      },
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}

