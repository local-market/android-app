import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_market/controller/category_controller.dart';
import 'package:local_market/views/sub_categories.dart';

class HorizontalList extends StatefulWidget {
  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {

  CategoryController _categoryController = new CategoryController();
  List <Map<String, String>> _categories = null;

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
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: this._categories != null ? this._categories.length : 0,
        itemBuilder: (context, i){
          return Category(
            image : 'assets/cats/dress.png',
            name : this._categories[i]['name'],
            id : this._categories[i]['id']
          );
        },
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
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => SubCategories(this.id)));
        },
        child: Container(
          width: 100.0,
          child: ListTile(
              title: Image.asset(
                image,
                width: 100.0,
                height: 80.0,
              ),
              subtitle: Container(
                alignment: Alignment.topCenter,
                child: Text(name),
              )),
        ),
      ),
    );
  }
}
