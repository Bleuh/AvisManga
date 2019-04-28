import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'dart:io';

class Upload {
  static Future<String> uploadProfilePicture(String imagePath) {
    final StorageReference storageRef = FirebaseStorage.instance.ref().child('profile_picture/' + Random().nextInt(10000).toString() + '_' + Random().nextInt(10000).toString() + '.${imagePath.split('.').last}');
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(imagePath),
    );
    return uploadTask.onComplete.then((downloadUrl) => downloadUrl.ref.getDownloadURL().then((url) => url));
  }

  static Future<void> removeProfilePicture(String imagePath) {
    String image = 'profile_picture' + imagePath.split('profile_picture').last.split('.png').first + '.png';
    image = image.replaceAll(new RegExp('%2F'), '/');
    final StorageReference storageRef = FirebaseStorage.instance.ref().child(image);
    return storageRef.delete();
  }
}
