import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileImageService {
  static Future<String> uploadFile(String filePath) async {
    File file = File(filePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profiles/$fileName');

    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
