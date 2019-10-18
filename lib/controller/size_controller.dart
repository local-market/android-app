import 'package:cloud_firestore/cloud_firestore.dart';


class SizeController {
  final Firestore _firestore = Firestore.instance;
  final ref = "size";

  Future<Map<String, bool> > get(String subCategoryId) async {
    DocumentSnapshot doc = await _firestore.collection(ref).document(subCategoryId).get();
    Map<String, bool> size = new Map<String, bool>();
    if(doc.data != null){
      for(var i = 0; i < doc.data['size'].length; i++){
        size[doc.data['size'][i]] = false;
      }
    }
    return size;
  }
}