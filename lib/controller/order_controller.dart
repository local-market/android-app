
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_market/controller/notification_controler.dart';
import "package:uuid/uuid.dart";

class OrderController {
  final Firestore _firestore = Firestore.instance;
  final String ref = "orders";
  final NotificationController _notificationController = new NotificationController();

  Future<String> add(Map<String, dynamic> cart, int deliveryCharge,String userId, String username, String address, String phone, String landmark) async {
    String orderId = Uuid().v1();
    var keys = cart.keys.toList();
    debugPrint("Adding to notification");
    String dateTime = new DateTime.now().toString();
    await _firestore.collection(ref).document(orderId).setData({
      "id" : orderId,
      "userId" : userId,
      "date" : dateTime,
      "username" : username,
      "address" : address,
      "phone" : phone,
      "landmark" : landmark,
      "deliveryCharge": deliveryCharge
    }).then((res){

      for(var i = 0; i < keys.length; i++){
      _notificationController.add(cart[keys[i]]['data']['vendorId'], username, phone, orderId, cart[keys[i]]['data'], dateTime, cart[keys[i]]['count']);
      _firestore.collection(ref).document(orderId).collection('products').add({
          "id" : cart[keys[i]]['data']['id'],
          "image" : cart[keys[i]]['data']['image'],
          "name" : cart[keys[i]]['data']['name'],
          "price" : cart[keys[i]]['data']['offerPrice'],
          "vendorId" : cart[keys[i]]['data']['vendorId'],
          "quantity" : cart[keys[i]]['count'],
          "size" : cart[keys[i]]['size']
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