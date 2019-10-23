import "package:firebase_storage/firebase_storage.dart";
import "dart:io";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import 'package:local_market/controller/user_controller.dart';

class Utils {
  final FirebaseStorage _fireabseStorage = FirebaseStorage.instance;
  final UserController _userController = new UserController();
  final Map<String, Color> colors = {
    "appBar" : Colors.white,
    //0XffDF1827
    "theme" : Color(0xff83b735),
    "appBarText" : Colors.grey.shade700,
    "appBarIcons" : Colors.grey.shade700,
    "icons" : Colors.grey.shade700,
    "textFieldBackground" : Colors.white,
    "buttonText" : Colors.white,
    "drawerIcons" : Colors.grey.shade700,
    "error" : Colors.red,
    "loading" : Color(0xff83b735),
    "loadingInverse" : Colors.white,
    "searchBarIcons" : Colors.grey.shade700,
    "pageBackground" : Colors.white,
    "drawerBackground" : Colors.white,
    "drawerHeader" : Colors.white,
    "drawerHeaderTe21xt" : Color(0xff83b735)
  };

  final String appName = "My Store";
  final double elevation = 2.0;

  Future<String> uploadImage(File image, String name) async {
    StorageUploadTask task = _fireabseStorage.ref().child(name).putFile(image);
    StorageTaskSnapshot snapshot = await task.onComplete.then((snapshot) => snapshot).catchError((e){
      print(e.toString());
    });
    var imageUrl = (await snapshot.ref.getDownloadURL()).toString();
    return imageUrl;
  }

  Future<bool> isLoggedIn() async {
    FirebaseUser user = await _userController.getCurrentUser();
    if(user == null){
      return false;
    }else{
      return true;
    }
  }

  String titleCase(String s){
    List<String> parts = new List<String>();
    parts = s.split(' ');
    String result = "";
    for(var i = 0; i < parts.length; i++){
      if(parts[i].length > 1){
        print(parts[i][0].substring(1));
        result += parts[i][0].toUpperCase() + parts[i].substring(1) + ' ';
      }else{
        result += parts[i][0].toUpperCase() + ' ';
      }
    }
    return result;
  }
}