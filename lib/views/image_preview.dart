import 'package:flutter/material.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/utils/utils.dart';

class ImagePreview extends StatelessWidget {

  String imageUrl;
  final Utils _utils = new Utils();
  ImagePreview(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Page(
      appBar: RegularAppBar(
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons']
        ),
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        elevation: _utils.elevation,
        // title: Text("Image Preview",
        //   style: TextStyle(
        //     color: _utils.colors['appBarText'],
        //   ),
        // ),
      ),
      children: <Widget>[
        PageItem(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              this.imageUrl,
              fit: BoxFit.contain,
              // width: 100,
              height: MediaQuery.of(context).size.height - 100,
            ),
          ),
        )
      ],
    );
  }
}