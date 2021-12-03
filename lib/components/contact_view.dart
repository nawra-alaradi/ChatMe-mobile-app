import 'package:chat_me/business_logic/chat_methods.dart';
import 'package:chat_me/business_logic/models/contact_model.dart';
import 'package:chat_me/business_logic/models/user_model.dart';
import 'package:chat_me/business_logic/providers/auth_provider.dart';
import 'package:chat_me/components/cached_image.dart';
import 'package:chat_me/components/custom_tile.dart';
import 'package:chat_me/components/last_message_container.dart';
import 'package:chat_me/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  final Contact contact;

  const ContactView({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatUser>(
      future: Provider.of<AuthProvider>(context, listen: false)
          .getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ChatUser? user = snapshot.data;

          return ViewLayout(
            contact: user!,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final ChatUser contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider userProvider = Provider.of<AuthProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        contact.name != null ? contact.name!.toUpperCase() : "..",
        style: TextStyle(
            color: Colors.black, fontFamily: "Works sans", fontSize: 19.sp),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.userModel.uid!,
          receiverId: contact.uid!,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60.h, maxWidth: 60.w),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 80.r,
              backgroundColor: Colors.amber,
              child: Text(
                contact.name![0].toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontFamily: 'Judson',
                    fontWeight: FontWeight.w700),
              ),
            ),
            // OnlineDotIndicator(
            //   uid: contact.uid,
            // ),
          ],
        ),
      ),
    );
  }
}
