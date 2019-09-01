import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_market/views/home.dart';

class user {

  final FirebaseAuth mAuth = FirebaseAuth.instance;

  Future<String> registerWithEmail(String email, String password) async {
    FirebaseUser user;
    try {
      user = await mAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "-1";
    }catch(e){
//      print(e.code);
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return 'Email already registered';
          break;
        case 'ERROR_INVALID_EMAIL':
          return 'Invalid Email';
          break;
        case 'ERROR_USER_NOT_FOUND':
          return 'User Not Found';
          break;
        case 'ERROR_WRONG_PASSWORD':
          return 'Wrong Password';
          break;
        default:
          return 'Error';
          break;
      }
    }
  }

  Future<List> loginWithEmail(String email, String password) async {
    FirebaseUser user;
    var error;
    try {
      user =
      await mAuth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          error = 'Invalid Email';
          break;
        case 'ERROR_USER_NOT_FOUND':
          error = 'User Not Found';
          break;
        case 'ERROR_WRONG_PASSWORD':
          error = 'Wrong Password';
          break;
        default:
          error = 'Error';
          break;
      }
    }
    return [user, error];
  }

  void ifLoggedIn(BuildContext context) async {
    if(await mAuth.currentUser() != null){
      print('true');
      FirebaseUser temp = await mAuth.currentUser();
      print(temp.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    }else{
      print('false');
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await mAuth.currentUser();
  }

  void logout() async {
    await mAuth.signOut();
  }

}