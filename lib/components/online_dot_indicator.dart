import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_me/enum/user_state.dart';
import 'package:chat_me/business_logic/models/user_model.dart';
import 'package:chat_me/business_logic/auth_methods.dart';
import 'package:chat_me/business_logic/initials_extractor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          ChatUser chatUser;

          if (snapshot.hasData && snapshot.data!.data() != null) {
            chatUser =
                ChatUser.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          }

          return Container(
            height: 10.h,
            width: 10.w,
            margin: EdgeInsets.only(right: 5.w, top: 5.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(3),
            ),
          );
        },
      ),
    );
  }
}
