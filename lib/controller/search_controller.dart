import 'package:cloud_firestore/cloud_firestore.dart';

class SearchController {
  final Firestore _firestore = Firestore.instance;
  final String ref = 'search';

  Future<List<Map<String, String> > > getN(String pattern, int n) async {
    pattern = pattern.toLowerCase();

    List<Map<String, String> > results = new List<Map<String, String> >();

    QuerySnapshot snapshot = await _firestore.collection(ref).orderBy('tag').startAt([pattern]).endAt([pattern + '\uf8ff']).limit(n).getDocuments();
    // print(document.toString());
    for(var i = 0; i < snapshot.documents.length; i++){
      DocumentSnapshot doc = snapshot.documents[i];
      results.add({
        "id" : doc.data['id'],
        "name" : doc.data['name'],
        "image" : doc.data['image'],
        "price" : doc.data['price'],
        "offerPrice" : doc.data['offerPrice'],
        "vendorId" : doc.data['vendorId']
      });
    }
    return results;
  }
}