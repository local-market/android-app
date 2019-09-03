import "package:firebase_storage/firebase_storage.dart";
import "dart:io";

class Utils {
  final FirebaseStorage _fireabseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String name) async {
    StorageUploadTask task = _fireabseStorage.ref().child(name).putFile(image);
    StorageTaskSnapshot snapshot = await task.onComplete.then((snapshot) => snapshot).catchError((e){
      print(e.toString());
    });
    var imageUrl = (await snapshot.ref.getDownloadURL()).toString();
    return imageUrl;
  }
}