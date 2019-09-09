import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/components/product_list_generator.dart';


class SearchBar extends SearchDelegate<String> {

  final ProductController _productController = new ProductController();
  List<Map<String, String> > _selectedProduct = new List<Map<String, String> >();
  Map<String, List<Map<String, String> > > _dp = new Map<String, List<Map<String, String> > >();
  List<Map<String, String> >  _products = new List<Map<String, String> > ();
  var _loading = false;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = "";
    },)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  dynamic data = Center(
    child: SpinKitCircle(color: Colors.red),
  );

  @override
  Widget buildResults(BuildContext context){
    // print(_selectedProduct.toString());
    print("loading: " + _loading.toString());

    // return data;
    
    if(_loading){
      return Center(
        child: SpinKitCircle(color: Colors.red),
      );
    }else{
      return ProductListGenerator(_selectedProduct);
    }

    // return 
    
    // if(_selectedProduct[0]['id'] == null){
    //   return Center(
    //     child: Text(_selectedProduct[0]['name'])
    //   );
    // }else{
    //   return SearchResults(_selectedProduct);
    // }
  }

  Future<List<Map<String, String> > > generateRelatedProducts(String pattern) async {
    List<String> relatedQueries = query.split('');
    relatedQueries.forEach((q) async {
      List<Map<String, String> > tempProducts = await _productController.getWithPattern(q);
      _selectedProduct = new List<Map<String, String> >.from(_selectedProduct)..addAll(tempProducts);
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query != null && query.length == 1){
      fillProducts(query);
    }
    // print(query);
    List<Map<String, String> > _productSuggestions = query.isEmpty ? _products : _products.where((product){
      return product["name"].startsWith(query.toLowerCase());
    }).toList();

    // print(_productSuggestions.toString());
    if(_productSuggestions == null){
      _productSuggestions = new List<Map<String, String> > ();
    }else if(_productSuggestions.isEmpty){
      _productSuggestions = [{
        "name" : query.toLowerCase(),
        "image" : null,
        "id" : null,
      }];
    }

    return ListView.builder(
      itemCount: _productSuggestions.length,
      itemBuilder: (context, index){
        return ListTile(
          onTap: (){
            _loading = true;
            // showResults(context);
            query = _productSuggestions[index]['name'];
            _productController.getRelated(query.toLowerCase()).then((relatedProducts) {
              // print('related products : '  + relatedProducts.toString());
              // return SearchResults(relatedProducts);
              _selectedProduct = relatedProducts;
              _loading = false;
              // data = SearchResults(_selectedProduct);
              // buildResults(context);
              showResults(context);
            });
            // showResults(context);
            // _selectedProduct.clear();
            // _selectedProduct.add(_productSuggestions[index]);
            // print(_selectedProduct);
            // query = _productSuggestions[index]['name'];
          },
          leading: Icon(Icons.search),
          title: RichText(
            text: TextSpan(
              
              text: _productSuggestions[index]['name'].substring(0, query.length),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
              children: [
                TextSpan(
                  text: _productSuggestions[index]['name'].substring(query.length),
                  style: TextStyle(
                    color: Colors.grey
                  )
                )
              ]
            )
          ),
        );
      },
    );
  }

  void fillProducts(String pattern) async {
    if(_dp[pattern] == null)
      _dp[pattern] = await _productController.getWithPattern(pattern);
      // print(_dp[pattern]);
      _products = _dp[pattern];
    // print(_products.toString());
  }

}