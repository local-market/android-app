import "package:flutter/material.dart";

class Page extends StatelessWidget {
  Widget appBar = null;
  List<Widget> children;
  Drawer drawer;
  Widget bottomNavigationBar;


  Page({
    this.appBar,
    @required this.children,
    this.drawer,
    this.bottomNavigationBar
  });

  List<Widget> generateBody(){
    List<Widget> list = new List<Widget>();
    if(appBar != null){
      list.add(appBar);
    }
    for(var i = 0; i < this.children.length; i++){
      list.add(this.children[i]);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: generateBody()
      ),
      drawer: drawer,
      bottomNavigationBar: this.bottomNavigationBar,
    );
  }
}

class PageItem extends StatelessWidget {

  Widget child;

  PageItem({
    @required this.child
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([child]),
    );
  }
}

class PageList extends StatelessWidget {

  List<Widget> children;
  
  PageList({
    @required this.children
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(children),
    );
  }

  static SliverList builder({@required itemCount, @required itemBuilder}){

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index){
          return itemBuilder(context, index);
        },
        childCount: itemCount,
        // semanticIndexOffset: itemCount,
      ),
    );
  }

  static SliverList separated({@required itemCount, @required itemBuilder, @required separatorBuilder}){
    // print(itemCount);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index){
          // print(index);
          final int itemIndex = index ~/ 2;
          if(index.isEven) return itemBuilder(context, itemIndex);
          // print('seprated ${index} : ${itemIndex}');
          return separatorBuilder(context, itemIndex);
        },
        semanticIndexCallback: (Widget widget, int localIndex) {
           if (localIndex.isEven) {
             return localIndex ~/ 2;
           }
           return null;
         },
        childCount: itemCount * 2,
        // semanticIndexOffset: 2,
      ),
    );
  }
}

class PageGrid extends StatelessWidget {

  List<Widget> children;
  var crossAxisCount = 1;

  PageGrid({
    @required this.children,
    @required this.crossAxisCount
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount
      ),
      delegate: SliverChildListDelegate(children),
    );
  }

  static SliverGrid builder({@required itemCount, @required gridDelegate,@required itemBuilder}){

    return SliverGrid(
      gridDelegate: gridDelegate,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index){
          return itemBuilder(context, index);
        },
        childCount: itemCount,
        // semanticIndexOffset: itemCount,
      ),
    );
  }
}