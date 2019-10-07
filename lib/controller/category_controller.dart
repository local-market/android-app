import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryController {
  final Firestore _firestore = Firestore.instance;
  final String ref = "category";
  final String subCategoryRef = "sub_category";

  Future<List<Map<String, String>>> getAll() async {
    QuerySnapshot snapshot = await _firestore.collection(ref).getDocuments();
    
    List<Map<String, String>> results = new List<Map<String, String>>();
    for(var i = 0; i < snapshot.documents.length; i++){
      DocumentSnapshot doc = snapshot.documents[i];
      results.add({
        "id" : doc.data['id'],
        "name" : doc.data['name']
      });
    }
    return results;
  }

  Future<List<Map<String, String>>> getSubCategory(String categoryId) async {
    QuerySnapshot snapshot = await _firestore.collection(ref).document(categoryId).collection(subCategoryRef).getDocuments();

    List<Map<String, String>> results = new List<Map<String, String>>();
    for(var i = 0; i < snapshot.documents.length; i++){
      DocumentSnapshot doc = snapshot.documents[i];
      results.add({
        "id" : doc.data['id'],
        "name" : doc.data['name']
      });
    }
    return results;
  }
}