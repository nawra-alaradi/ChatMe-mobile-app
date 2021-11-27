import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

class ChatMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _messageCollection =
      _firestore.collection("messages");

  final CollectionReference _userCollection = _firestore.collection("users");
  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map as Map<String, dynamic>);

    _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map as Map<String, dynamic>);
  }

  Stream<QuerySnapshot> fetchContacts(String userId) =>
      _userCollection.doc(userId).collection("contacts").snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    required String senderId,
    required String receiverId,
  }) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
