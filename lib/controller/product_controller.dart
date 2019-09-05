import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:local_market/controller/user_controller.dart';
import "package:uuid/uuid.dart";
import "package:local_market/utils/utils.dart";
import "dart:io";

class ProductController {
  final Firestore _firestore = Firestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final String ref = "products";
  final String vendor_ref = "vendors";
  final UserController _userController = new UserController();

  Future<void> add(File productImage, String productName, String userId, Map<String, String> productDetails) async {
    String productId = Uuid().v1();
    String imageUrl = await Utils().uploadImage(productImage, productId);
    // print("Image Url " + imageUrl);
    // productDetails["image"] = imageUrl;
    _firestore.collection(ref).document(productId).setData(
      {
        "id" : productId,
        "name" : productName.toLowerCase(),
        "image" : imageUrl
      }).then((value){
      _firestore.collection(ref).document(productId).collection(vendor_ref).document(userId).setData(productDetails).then((value){
        _firestore.collection('users').document(userId).collection(ref).document(productId).setData({
          "inStock":true,
          "id" : productId
          }).catchError((e){
          throw e;
        });
      }).catchError((e){
        throw e;
      });
    }).catchError((e){
      print(e.toString());
    });
  }

  Future<List<Map<String, String> > > getWithPattern(String pattern) async {
    pattern = pattern.toLowerCase();

    List<Map<String, String> > results = new List<Map<String, String> >();

    QuerySnapshot snapshot = await _firestore.collection(ref).orderBy('name').startAt([pattern]).endAt([pattern + '\uf8ff']).getDocuments();
    // print(document.toString());
    snapshot.documents.forEach((doc){
      results.add({
        "id" : doc.data['id'],
        "name" : doc.data['name'],
        "image" : doc.data['image']
      });
    });
    return results;
  }

  Future<List<Map<String, String> > > getRelated(String pattern) async {
    List<Map<String, String> > results = new List<Map<String, String> >();
    Map<String, bool> dp = new Map<String, bool>();
    pattern = pattern.toLowerCase();
    final relatedPatterns = pattern.split(' ');
    for(var i = 0; i < relatedPatterns.length; i++){
      QuerySnapshot snapshot = await _firestore.collection(ref).orderBy('name').startAt([pattern]).endAt([pattern + '\uf8ff']).getDocuments();
      snapshot.documents.forEach((doc){
        // print('dp : ' + dp[doc.data['id']].toString());
        if(dp[doc.data['id']] == null){
          results.add({
            "id" : doc.data['id'],
            "name" : doc.data['name'],
            "image" : doc.data['image']
          });
          dp[doc.data['id']] = true;
        }
      });
    }
    return results;
  }

  Future<List<Map<String, String> > > getVendors(String productId) async {
    List<Map<String, String> > results = new List<Map<String, String> >();
    QuerySnapshot snapshot = await _firestore.collection(ref).document(productId).collection('vendors').getDocuments();
    for(var i = 0; i < snapshot.documents.length; i++){
      DocumentSnapshot doc = snapshot.documents[i];
      DocumentSnapshot vendor = await _userController.getUser(doc.data['id']);
      // print(doc.data.toString());
      // print(doc.data['id'].toString());
      // print(vendor.data.toString());
      results.add({
        "price" : doc.data['price'],
        "inStock" : doc.data['inStock'],
        "name" : vendor.data['username'],
        "id" : doc.data['id']
      });
    }
    // print(results);
    return results;
  }

  Future<DocumentSnapshot> get(String id) async {
    return (await _firestore.collection(ref).document(id).get());
  }

  Future<DocumentSnapshot> getPrice(String pid, String uid) async {
    return (await _firestore.collection(ref).document(pid).collection(vendor_ref).document(uid).get());
  }
}