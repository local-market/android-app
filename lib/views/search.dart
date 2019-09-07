import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/product_list_generator.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/utils/utils.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController _queryTextController = new TextEditingController();
  String query = "";
  final ProductController _productController = new ProductController();
  List<Map<String, String> > _selectedProduct = new List<Map<String, String> >();
  Map<String, List<Map<String, String> > > _dp = new Map<String, List<Map<String, String> > >();
  List<Map<String, String> >  _products = new List<Map<String, String> > ();
  final Utils _utils = new Utils();
  bool _loading = false;
  bool _searching = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _utils.colors['pageBackground'],
      appBar: AppBar(
        iconTheme: IconThemeData(color: _utils.colors['appBarIcons']),
        backgroundColor: _utils.colors['appBar'],
        elevation: _utils.elevation,
        leading: buildLeading(context),
        title: TextField(
          controller: _queryTextController,
          autofocus: true,
          onChanged: (value){
            setState(() {
              query = value;
              _searching = true;
            });
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search"
          ),
        ),
        actions: buildActions(),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _searching ? buildSuggestions(context) : buildResults(context),
      ),
    );
  }

  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: _utils.colors['searchBarIcons'],
      ),
    );
  }

  List<Widget> buildActions() {
    if(query.length > 0){
      return [
        IconButton(
          onPressed: (){
            setState(() {
              query = "";
              _queryTextController.text = "";
            });
          },
          icon: Icon(Icons.close),
          color: _utils.colors['searchBarIcons'],
        )
      ];
    }else return [];
  }

  Future<void> generateProductsForResults(String pattern) async {
    List<Map<String, String> > relatedProducts = await _productController.getRelated(pattern);
    setState(() {
      _selectedProduct = relatedProducts;
      _loading = false;
    });
  }

  Widget buildResults(BuildContext context){

    if(_loading){
      return Center(
        child: SpinKitCircle(color: _utils.colors['loading']),
      );
    }else{
      return ProductListGenerator(_selectedProduct, false);
    }
  }

  Widget buildSuggestions(BuildContext context) {

    // print("Build Suggestions");
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
            generateProductsForResults(query.toLowerCase());
            setState(() {
              _loading = true;
              _searching = false;
              query = _productSuggestions[index]['name'];
              _queryTextController.text = query;
            });
          },
          leading: Icon(Icons.search,
            color: _utils.colors['searchBarIcons'],
          ),
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

  Future<void> fillProducts(String pattern) async {
    if(_dp[pattern] == null)
      _dp[pattern] = await _productController.getWithPattern(pattern);
      setState(() {
        _products = _dp[pattern];
      });
  }
}