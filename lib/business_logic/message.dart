import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId = "";
  String receiverId = "";
  String type = "";
  String message = "";
  Timestamp timestamp = Timestamp.now();
  String photoUrl = "";

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.type,
      required this.message,
      required this.timestamp});

  //Will be only called when you wish to send an image
  Message.imageMessage(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.type,
      required this.timestamp,
      required this.photoUrl});

  Map toMap() {
    Map<String, dynamic> map = {};
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['type'] = type;
    map['message'] = message;
    map['timestamp'] = timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = message;
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['type'] = type;
    map['timestamp'] = timestamp;
    map['photoUrl'] = photoUrl;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    // Message _message = Message(
    //     senderId: "",
    //     receiverId: "receiverId",
    //     type: "type",
    //     message: "message",
    //     timestamp: Timestamp.now());
    senderId = map['senderId'];
    receiverId = map['receiverId'];
    type = map['type'];
    message = map['message'];
    timestamp = map['timestamp'];
  }
}
