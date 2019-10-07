import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/product_view.dart';

class Products extends StatefulWidget {
  String _subCategoryId;

  Products(String subCategoryId){
    this._subCategoryId = subCategoryId;
  }

  @override
  _ProductsState createState() => _ProductsState(this._subCategoryId);
}

class _ProductsState extends State<Products> {

  final Utils _utils = new Utils();
  final ProductController _productController = new ProductController();
  String _subCategoryId;
  _ProductsState(this._subCategoryId);
  bool _loading = true;

  List<DocumentSnapshot> _products = null;

  @override
  void initState() {
    super.initState();
    _productController.getByCategoryId(this._subCategoryId).then((products){
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
}