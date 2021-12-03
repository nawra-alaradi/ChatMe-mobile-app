import 'package:chat_me/business_logic/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/contact_model.dart';
import 'models/message.dart';

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

  //fetches user contacts
  Stream<QuerySnapshot> fetchContacts({required String userId}) =>
      _userCollection.doc(userId).collection("contacts").snapshots();
//fetches last message between two users
  Stream<QuerySnapshot> fetchLastMessageBetween({
    required String senderId,
    required String receiverId,
  }) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  Future<void> addMessageToDb(
      Message message, ChatUser sender, ChatUser receiver) async {
    Map<String, dynamic> map = message.toMap() as Map<String, dynamic>;
    //add the message content as a document to the messages collection => senderId doc=> collection of received messages from other users
    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);
    addToContacts(senderId: message.senderId, receiverId: message.receiverId);
    //add the message content as a document to the messages collection => receiverId doc=> collection of received messages from other users
    await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument(
          {required String of, required String forContact}) =>
      _userCollection.doc(of).collection("contacts").doc(forContact);

  addToContacts({required String senderId, required String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }
}
