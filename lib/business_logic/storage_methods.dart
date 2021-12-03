import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'providers/image_upload_provider.dart';
import 'models/message.dart';
import 'models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_me/business_logic/chat_methods.dart';

class StorageMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // FirebaseStorage? _storageReference;

  //user class
  ChatUser user = ChatUser(uid: '', name: '', gender: '', email: '');

  Future<String?> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      UploadTask storageUploadTask = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}')
          .putFile(imageFile);
      TaskSnapshot snapshot = await storageUploadTask;
      String url = await (await snapshot.ref.getDownloadURL());
      print("This is the url $url");
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void setImageMessage(String url, String receiverId, String senderId) async {
    Message _message = Message.imageMessage(
        senderId: senderId,
        receiverId: receiverId,
        message: "IMAGE",
        type: "image",
        timestamp: Timestamp.now(),
        photoUrl: url);
    Map<String, dynamic> map = _message.toImageMap() as Map<String, dynamic>;
    //set the data to the database
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);
    //add the message content as a document to the messages collection => receiverId doc=> collection of received messages from other users
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage({
    required File image,
    required String receiverId,
    required String senderId,
    required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String? url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url!, receiverId, senderId);
  }

  Future<File?> pickImage({required ImageSource source}) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    print('Path $path');
    try {
      //imageQuality: 85,
      final image = await ImagePicker()
          .pickImage(source: source, maxWidth: 400, maxHeight: 400);
      print('image is picked');
      if (image == null) {
        print('image is null');
        return null;
      } else {
        //$path/image_$random.jpg
        // var file = File('image_$random/${image.path}');

        return File(image.path);
      }
    } catch (e) {
      print('Failed to pick image $e');
    }
  }
}
