import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";
import "package:uuid/uuid.dart";
import "package:local_market/utils/utils.dart";
import "dart:io";

class ProductController {
  final Firestore _firestore = Firestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final String ref = "products";

  Future<void> add(File productImage, Map<String, String> productDetails) async {
    String productId = Uuid().v1();
    String imageUrl = await Utils().uploadImage(productImage, productId);
    print("Image Url " + imageUrl);
    productDetails["image"] = imageUrl;
    _firestore.collection(ref).document(productId).setData(productDetails).catchError((e){
      print(e.toString());
    });
  }
}