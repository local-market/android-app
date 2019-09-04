import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";
import "package:uuid/uuid.dart";
import "package:local_market/utils/utils.dart";
import "dart:io";

class ProductController {
  final Firestore _firestore = Firestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final String ref = "products";
  final String vendor_ref = "vendors";

  Future<void> add(File productImage, String productName, String userId, Map<String, String> productDetails) async {
    String productId = Uuid().v1();
    String imageUrl = await Utils().uploadImage(productImage, productId);
    print("Image Url " + imageUrl);
    // productDetails["image"] = imageUrl;
    _firestore.collection(ref).document(productId).setData(
      {
        "id" : productId,
        "name" : productName.toLowerCase(),
        "image" : imageUrl
      }).then((value){
      _firestore.collection(ref).document(productId).collection(vendor_ref).document(userId).setData(productDetails).then((value){
        _firestore.collection('users').document(userId).collection(ref).document(productId).setData({"inStock":true}).catchError((e){
          throw e;
        });
      }).catchError((e){
        throw e;
      });
    }).catchError((e){
      print(e.toString());
    });
  }

  Future<List<Object> > getWithPattern(String pattern) async {
    pattern = pattern.toLowerCase();

    List<Object> results = new List<Object>();

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
}