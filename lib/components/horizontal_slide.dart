import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/category_controller.dart';
import 'package:local_market/views/sub_categories.dart';

class HorizontalList extends StatefulWidget {
  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {

  CategoryController _categoryController = new CategoryController();
  List <Map<String, String>> _categories = new List<Map<String, String>>();

  @override
  void initState() {
    super.initState();
    _categoryController.getAll()
    .then((categories){
      setState(() {
        this._categories = categories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 285.0,
      child: GridView.count(
        primary: false,
        crossAxisCount: 4,
        // padding: const EdgeInsets.fromLTRB(0, 20, 0,20),
        childAspectRatio: 0.85,
        children: this._categories.map((category){
          return Category(
            image : 'assets/cats/dress.png',
            name : category['name'],
            id : category['id']
          );
        }).toList(),
        // scrollDirection: Axis.horizontal,
        // itemCount: this._categories != null ? this._categories.length : 0,
        // itemBuilder: (context, i){
        //   return Category(
        //     image : 'assets/cats/dress.png',
        //     name : this._categories[i]['name'],
        //     id : this._categories[i]['id']
        //   );
        // },
      )
    );
  }
}

class Category extends StatelessWidget {
  final String image;
  final String name;
  final String id;

  Category({this.image, this.name, this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => SubCategories(this.id)));
        },
        child: ListTile(
            title: Image.asset(
              image,
              height: 40,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(name, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
            ),
            ),
      );
  }
}
