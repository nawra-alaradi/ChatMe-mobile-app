class ChatUser {
  String? uid;
  String? name;
  String? gender;
  // final String birthDate;
  // final String nationality;
  // final String phone;
  String? email;

  ChatUser({
    required this.uid,
    required this.name,
    required this.gender,
    // required this.birthDate,
    // required this.nationality,
    // required this.phone,
    required this.email,
  });

  ChatUser.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    name = mapData['name'];
    email = mapData['email'];
    gender = mapData['gender'];
  }
}
