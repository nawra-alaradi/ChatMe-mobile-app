import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_model.dart';
import 'message.dart';

class AuthProvider with ChangeNotifier {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  ChatUser _chatUser = ChatUser(uid: "", name: "", gender: "", email: "");
  ChatUser get userModel => _chatUser;
  FirebaseAuth get auth => _auth;
  User? get user => _user;
  Future<String> chatUserSignIn(String? email, String? password) async {
    if (email != null && password != null) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        _user = userCredential.user;

        if (_user != null && !_user!.emailVerified) {
          return 'Your email has not been verified. Please verify your email';
        } else {
          //user has verified his email
          if (_user != null) {
            //user has verified his email
            final String uid = _user!.uid;
            print('User uid is $uid');
            DocumentSnapshot documentDetails = await _firestore.doc(uid).get();
            print(documentDetails.data());
            _chatUser = ChatUser(
                uid: _user!.uid,
                name: documentDetails['name'],
                gender: documentDetails['gender'],
                email: documentDetails['email']);
            print('name: ${_chatUser.name}');
            print('gender: ${_chatUser.gender}');
            print('email: ${_chatUser.email}');
            notifyListeners(); //inform listeners about the  user details
            return 'signed in successfully';
          }
        }
      } on FirebaseAuthException catch (e) {
        print('part1 is caught with error ${e.toString()}');
        print(e.toString());
        return 'Invalid password';
      } catch (e) {
        print('part2 is caught with error ${e.toString()}');
        return 'Unverified email';
      }
      return 'sth wrong';
    } else {
      return 'no email and password are provided';
    }
  }

  Future<String> registerNewUser(
      String name,
      String gender,
      // String DOB,
      String email,
      String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      //send email verification to the user
      if (!_user!.emailVerified) {
        await _user!.sendEmailVerification();
      }
      //create a new document inside users collection with the user credentials
      print('this part is being executed');
      await _firestore.doc(_user!.uid).set({
        'uid': _user!.uid,
        'name': name,
        'gender': gender,
        // 'date of birth': DOB,
        // 'nationality': nationality,
        'email': email.toLowerCase(),
        'createdOn': FieldValue.serverTimestamp()
        // ignore: invalid_return_type_for_catch_error
      }).catchError((onError) {
        print('failed to add the patient $onError');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for this email.';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
    //todo: sign the user out to enforce email verificaton
    return 'An account with the email address $email has been successfully created. Please verify your account. Check your email inbox.';
  }

  //TODO: I am not sure if i need to add notify listeners here
  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'A reset email message has been sent';
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<ChatUser>> fetchAllUsers(User currentUser) async {
    List<ChatUser> userList = [];

    QuerySnapshot querySnapshot = await _firestore.get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(ChatUser.fromMap(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, ChatUser sender, ChatUser receiver) async {
    Map<String, dynamic> map = message.toMap() as Map<String, dynamic>;
    //add the message content as a document to the messages collection => senderId doc=> collection of received messages from other users
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);
    //add the message content as a document to the messages collection => receiverId doc=> collection of received messages from other users
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  // static String formatDateString(String dateString) {
  //   DateTime dateTime = DateTime.parse(dateString);
  //   var formatter = DateFormat('dd/MM/yy');
  //   return formatter.format(dateTime);
  // }
}
