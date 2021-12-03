import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  late final String uid;
  late final Timestamp addedOn;

  Contact({
    required this.uid,
    required this.addedOn,
  });

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['contact_id'];
    addedOn = mapData["added_on"];
  }
}
