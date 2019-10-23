import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_market/utils/utils.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  final Utils _utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons']
        ),
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        elevation: 0,
      ),
      backgroundColor: _utils.colors['pageBackground'],
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 5),
              child: Container(
                alignment: Alignment.topCenter,
                child: Transform.rotate(
                  angle: - 3.14 / 10,
                  child: SvgPicture.asset('assets/svg/logo.svg',
                    color: _utils.colors['theme'],
                    width: 150,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 0, 0),
              child: Center(
                child: Text(
                  "Thatipur, Gwalior (M.P.)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 0, 0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(OMIcons.phone),
                    Text(
                      " +918085256404\n +917987519280",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 0, 0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(OMIcons.email),
                    Text(
                      " onlinelocalmarket@gmail.com",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      )
                    ),
                  ],
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20 , 33, 8),
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                color: _utils.colors['theme'],
                // elevation: _utils.elevation,
                child: MaterialButton(
                  onPressed: () async {
                    var url = 'mailto:onlinelocalmarket@gmail.com?body=Name:\nMobile:\nAddress:';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  minWidth: MediaQuery.of(context).size.width /2,
                  child: Text(
                    "Email Us",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _utils.colors['buttonText'],
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}