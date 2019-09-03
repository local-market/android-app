import "package:firebase_storage/firebase_storage.dart";
import "dart:io";
import "package:firebase_auth/firebase_auth.dart";

class Utils {
  final FirebaseStorage _fireabseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> uploadImage(File image, String name) async {
    StorageUploadTask task = _fireabseStorage.ref().child(name).putFile(image);
    StorageTaskSnapshot snapshot = await task.onComplete.then((snapshot) => snapshot).catchError((e){
      print(e.toString());
    });
    var imageUrl = (await snapshot.ref.getDownloadURL()).toString();
    return imageUrl;
  }

  Future<bool> isLoggedIn() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user == null){
      return false;
    }else{
      return true;
    }
  }
}