import 'package:flutter/material.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: FloatingAppBar(
        title: Text("Hello World"),
        leading: Icon(Icons.menu),
        brightness: Brightness.light,
        actions: <Widget>[
          Icon(Icons.search),
          Icon(Icons.security)
        ],
      ),
      children: <Widget>[
        PageList(
          children: <Widget>[
            Text("Hello World1"),
            Text("Hello World1"),
            Text("Hello World1"),
          ],
        ),
        PageGrid(
          crossAxisCount: 4,
          children: <Widget>[
            Text("Hello World2"),
            Text("Hello World3"),
            Text("Hello World2"),
            Text("Hello World3"),
            Text("Hello World2"),
            Text("Hello World3"),
            Text("Hello World2"),
            Text("Hello World3")
          ],
        ),
        PageList(
          children: <Widget>[
            Text("Hello World1"),
            Text("Hello World1"),
            Text("Hello World1"),
            Text("Hello World1"),
            Text("Hello World1"),
            Text("Hello World1"),
            Text("Hello World1"),
            Text("Hello World1"),
            Text("Hello World1"),
          ],
        ),
        Form(
          child: PageList(
            children: <Widget>[
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
              Text("Hello world 4"),
            ],
          ),
        )
      ],
    );
  }
}