import 'package:chat_me/business_logic/chat_methods.dart';
import 'package:chat_me/business_logic/models/contact_model.dart';
import 'package:chat_me/business_logic/providers/auth_provider.dart';
import 'package:chat_me/components/contact_view.dart';
import 'package:chat_me/components/custom_appbar.dart';
import 'package:chat_me/components/new_chat_button.dart';
import 'package:chat_me/components/pickup_layout.dart';
import 'package:chat_me/components/quiet_box.dart';
import 'package:chat_me/components/user_circle.dart';
import 'package:chat_me/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);
  static const String id = "ChatListScreen";
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: null,
      title: const UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 25.w,
          ),
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.id);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: const Color(0xFFE1E2E1),
        appBar: customAppBar(context),
        floatingActionButton: const NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();
  ChatListContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: authProvider.user!.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data!.docs;

              if (docList.isEmpty) {
                return const QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10.w),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(
                      docList[index].data() as Map<String, dynamic>);

                  return ContactView(contact: contact);
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
