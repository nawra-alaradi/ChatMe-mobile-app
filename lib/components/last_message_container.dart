import 'package:chat_me/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_me/business_logic/models/message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;

  const LastMessageContainer({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data!.docs;
          if (docList.isNotEmpty) {
            Message message =
                Message.fromMap(docList.last.data() as Map<String, dynamic>);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                message.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          return Text(
            "No Message",
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontSize: 14.sp,
            ),
          );
        }
        return Text("..",
            style: kBodyTextStyle.copyWith(
                fontSize: 14.sp, color: Colors.blueGrey[800]));
      },
    );
  }
}
