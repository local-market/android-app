import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_market/controller/product_controller.dart';

class UserController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Firestore _firestore = Firestore.instance;
  final String ref = "users";
  // final ProductController _productController = new ProductController();

  void createUser(Map<String, String> values) {
    print(values.toString());
    String uid = values['uid'];
    _firestore.collection(ref).document(uid).setData(values).catchError((e){
      print(e.toString());
    });
  }

  void logout() async {
    await _firebaseAuth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    // print((await _firebaseAuth.currentUser()).toString());
    return (await _firebaseAuth.currentUser());
  }

  Future<DocumentSnapshot> getUser(String uid) async{
    print("User Controller1: " + uid.toString());
    DocumentSnapshot user = await _firestore.collection(ref).document(uid).get();
    return user;
  }

  Future<DocumentSnapshot> getCurrentUserDetails() async {
    FirebaseUser user = await getCurrentUser();
    if(user != null)
      return (await getUser(user.uid.toString()));
    else return null;
  }

  Future<List<Map<String, String> > > getAllProducts(String uid) async {
    List<Map<String, String> > results = new List<Map<String, String> >();
    QuerySnapshot products = await _firestore.collection(ref).document(uid).collection('products').getDocuments();
    for(var i = 0; i < products.documents.length; i++){
      DocumentSnapshot product = products.documents[i];
      DocumentSnapshot productDetails = await ProductController().get(product.data['id']);
      results.add({
        "id" : productDetails.data['id'],
        "name" : productDetails.data['name'],
        "image" : productDetails.data['image']
      });
    }
    return results;
  }

  Future<void> update(String uid, Map<String, String> details) async {
    await _firestore.collection(ref).document(uid).updateData(details);
  }

  Future<void> linkWithCredential(FirebaseUser user, AuthCredential credential) async {
    await user.linkWithCredential(credential).catchError((e){
      throw e;
    });
  }
}