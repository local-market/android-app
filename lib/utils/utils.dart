import "package:firebase_storage/firebase_storage.dart";
import "dart:io";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';

class Utils {
  final FirebaseStorage _fireabseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Map<String, Color> colors = {
    "appBar" : Colors.white,
    "theme" : Colors.deepPurple,
    "appBarText" : Colors.deepPurple,
    "appBarIcons" : Colors.deepPurple,
    "icons" : Colors.grey,
    "textFieldBackground" : Colors.white,
    "buttonText" : Colors.white,
    "drawerIcons" : Colors.grey,
    "error" : Colors.red,
    "loading" : Colors.deepPurple,
    "loadingInverse" : Colors.white,
    "searchBarIcons" : Colors.grey,
    "pageBackground" : Colors.white,
    "drawerBackground" : Colors.white
  };
  final elevation = 1.0;

  Future<String> uploadImage(File image, String name) async {
    StorageUploadTask task = _fireabseStorage.ref().child(name).putFile(image);
    StorageTaskSnapshot snapshot = await task.onComplete.then((snapshot) => snapshot).catchError((e){
      print(e.toString());
    });
    var imageUrl = (await snapshot.ref.getDownloadURL()).toString();
    return imageUrl;
  }

  Future<bool> isLoggedIn() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user == null){
      return false;
    }else{
      return true;
    }
  }
}