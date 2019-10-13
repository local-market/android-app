
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:uuid/uuid.dart";

class OrderController {
  final Firestore _firestore = Firestore.instance;
  final String ref = "orders";

  Future<String> add(Map<String, dynamic> cart, String userId, String username, String address, String phone, String landmark) async {
    String orderId = Uuid().v1();
    var keys = cart.keys.toList();
    await _firestore.collection(ref).document(orderId).setData({
      "id" : orderId,
      "userId" : userId,
      "date" : new DateTime.now().toString(),
      "username" : username,
      "address" : address,
      "phone" : phone,
      "landmark" : landmark
    }).then((res){
      for(var i = 0; i < keys.length; i++){
      _firestore.collection(ref).document(orderId).collection('products').add({
          "id" : cart[keys[i]]['data']['id'],
          "image" : cart[keys[i]]['data']['image'],
          "name" : cart[keys[i]]['data']['name'],
          "price" : cart[keys[i]]['data']['price'],
          "vendorId" : cart[keys[i]]['data']['vendorId'],
          "quantity" : cart[keys[i]]['count']
        }).catchError((e){
          throw(e);
        });
      }      
    }).catchError((e){
      throw e;
    });
    return orderId;
  }

  Future<List<DocumentSnapshot>> getByUserId(String userId) async {
    QuerySnapshot snapshot = await _firestore.collection(ref).orderBy('userId').startAt([userId]).endAt([userId + '\uf8ff']).getDocuments();
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> getOrderProducts(String orderId) async {
    QuerySnapshot snapshot = await _firestore.collection(ref).document(orderId).collection('products').getDocuments();

    return snapshot.documents;
  }
}