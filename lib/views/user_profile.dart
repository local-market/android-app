import "package:flutter/material.dart";
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/utils/utils.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _userPhoneNumberController = new TextEditingController();
  TextEditingController _userAddressController = new TextEditingController();
  final Utils _utils = new Utils();


  @override
  Widget build(BuildContext context) {
    this._userNameController.text = "John Smith";
    this._userPhoneNumberController.text = "7692909306";
    this._userAddressController.text = "Qtr. no. 81 Tilak Nagar";

    return Page(
      appBar: RegularAppBar(
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons']
        ),
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        elevation: _utils.elevation,
        title: Text("My Account",
          style: TextStyle(
            color: _utils.colors['appBarText'],
          ),
        ),
      ),
      children: <Widget>[
        PageList(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: ListTile(
            //     title: TextFormField(
            //       enabled: false,
            //       textAlign: TextAlign.left,
            //       decoration: InputDecoration(hintText: "User Name", border: InputBorder.none),
            //       controller: _userNameController,
            //     ),
            //   ),
            // ),

            ListTile(
              title: TextFormField(
                enabled: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    hintText: "User Name",
                    border: InputBorder.none,
                    prefixIcon: Icon(OMIcons.person)),
                controller: _userNameController,
              ),
            ),

            ListTile(
              title: TextFormField(
                // enabled: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    hintText: "Phone Number",
                    border: InputBorder.none,
                    prefixIcon: Icon(OMIcons.phone)),
                controller: _userPhoneNumberController,
              ),
            ),

            ListTile(
              title: TextFormField(
                // enabled: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    hintText: "Address",
                    border: InputBorder.none,
                    prefixIcon: Icon(OMIcons.myLocation)),
                controller: _userAddressController,
              ),
            ),

            Padding(padding: const EdgeInsets.all(10.0),
              child: FlatButton(child: Text("Save"), onPressed: () {
                print("Saving: "+_userPhoneNumberController.text+", "+_userAddressController.text);
              }, splashColor: Colors.white70, color: Colors.blue, textTheme: ButtonTextTheme.primary,),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(
            //     bottom: 10.0,
            //     left: 10.0,
            //     right: 10.0
            //   ),
            //   child: ListTile(
            //     title: TextFormField(
            //       // enabled: false,
            //       textAlign: TextAlign.left,
            //       decoration: InputDecoration(hintText: "User Name"),
            //       controller: _userNameController,
            //     ),
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}