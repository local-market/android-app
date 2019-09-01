import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final String ref = "users";

  void createUser(Map values) {
    print(values.toString());
    String uid = values['uid'];
    _database.reference().child('$ref/$uid').set(values).catchError((e) {
      print(e.toString());
    });
  }

  void logout() async {
    await _firebaseAuth.signOut();
  }

}