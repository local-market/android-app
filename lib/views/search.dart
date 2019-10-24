import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/components/product_list_generator.dart';
import 'package:local_market/controller/product_controller.dart';
import 'package:local_market/controller/search_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/utils/globals.dart' as globals;

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController _queryTextController = new TextEditingController();
  String query = "";
  final ProductController _productController = new ProductController();
  final SearchController _searchController = new SearchController();
  List<Map<String, String> > _selectedProduct = new List<Map<String, String> >();
  // Map<String, List<Map<String, String> > > _dp = new Map<String, List<Map<String, String> > >();
  List<Map<String, String> >  _products = new List<Map<String, String> > ();
  final Utils _utils = new Utils();
  bool _loading = false;
  bool _searching = true;

  @override
  Widget build(BuildContext context) {

    return Page(
      appBar: RegularAppBar(
        brightness: Brightness.light,
        backgroundColor: _utils.colors['appBar'],
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons'],
        ),
        elevation: _utils.elevation,
        leading: buildLeading(context),
        title: TextField(
          controller: _queryTextController,
          autofocus: true,
          autocorrect: true,
          onChanged: (value){
            // print(value);
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
      
      children: <Widget>[
        _searching ? buildSuggestions(context) : buildResults(context)
        
        // PageItem(
        //   child: _searching ? buildSuggestions(context) : buildResults(context),
        //   ),
      ],
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
      return PageItem(
        child: SpinKitCircle(color: _utils.colors['loading']),
      );
    }else{
      return ProductListGenerator(_selectedProduct, false);
    }
  }

  Widget buildSuggestions(BuildContext context) {

    // print("Build Suggestions");
    if(query != null && query.length > 0){
      fillProducts(query.toLowerCase());
    }
    print(query);
    // print(_products);
    List<Map<String, String> > _productSuggestions = _products;

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

    return PageList.builder(
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
          title: _productSuggestions[index]['name'].indexOf(query.toLowerCase()) == -1 ? 
          Text(
            _productSuggestions[index]['name'],
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold
            ),
          ) : 
          RichText(
            text: TextSpan(
              
              text: _productSuggestions[index]['name'].substring(0, _productSuggestions[index]['name'].indexOf(query.toLowerCase())),
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold
              ),
              children: [
                TextSpan(
                  text: _productSuggestions[index]['name'].substring(_productSuggestions[index]['name'].indexOf(query.toLowerCase()), _productSuggestions[index]['name'].indexOf(query.toLowerCase()) + query.length),
                  style: TextStyle(
                    color: Colors.black
                  )
                ),
                TextSpan(
                  text: _productSuggestions[index]['name'].substring(_productSuggestions[index]['name'].indexOf(query.toLowerCase()) + query.length),
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
    if(globals.searchCache[pattern] == null){
      if(pattern.length == 1){
        print('getting1..');
        globals.searchCache[pattern] = await _searchController.getN(pattern, 20);
      }else{
        String relative_pattern = pattern.substring(0, pattern.length - 1);
        if(globals.searchCache[relative_pattern] == null){
          print('getting data');
          globals.searchCache[pattern] = await _searchController.getN(pattern, 20);
        }else{
          bool pattern_found = false;

          // _products = new List<Map<String, String>>();
          globals.searchCache[pattern] = new List<Map<String, String>>();
          for(var i = 0; i < globals.searchCache[relative_pattern].length; i++){
            if(globals.searchCache[relative_pattern][i]['name'].indexOf(pattern) > 0){
              // print('Hello');
              pattern_found = true;
              
              globals.searchCache[pattern].add(globals.searchCache[relative_pattern][i]);
            }
          }
          if(!pattern_found){
            print('asdgetting data');
            globals.searchCache[pattern] = await _searchController.getN(pattern, 15);
          }
        }
      }
    }
    setState(() {
      _products = globals.searchCache[pattern];
      // print(_products);
    });
  }
}