import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Firestore _firestore = Firestore.instance;
  final String ref = "users";

  void createUser(Map<String, String> values) {
    print(values.toString());
    String uid = values['uid'];
    _firestore.collection(ref).document(uid).setData(values).catchError((e){
      print(e.toString());
    });
    // _database.reference().child('$ref/$uid').set(values).catchError((e) {
    //   print(e.toString());
    // });
  }

  void logout() async {
    await _firebaseAuth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    return (await _firebaseAuth.currentUser());
  }

}