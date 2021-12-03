import 'dart:io';
import 'package:chat_me/business_logic/chat_methods.dart';

import '../business_logic/providers/auth_provider.dart';
import '../business_logic/models/user_model.dart';
import 'package:chat_me/components/cached_image.dart';
import 'package:chat_me/enum/view_state.dart';
import 'package:flutter/material.dart';
import 'package:chat_me/components/custom_appbar.dart';
import 'package:chat_me/components/custom_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../business_logic/models/message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:chat_me/universal_colors.dart';
import '../business_logic/providers/image_upload_provider.dart';
import '../business_logic/storage_methods.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser receiver;
  static const String id = 'ChatScreen';
  const ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  ChatUser? sender;
  String _currentUserId = "  ";
  FocusNode textFieldFocus = FocusNode();
  StorageMethods storageMethods = StorageMethods();
  late ImageUploadProvider _imageUploadProvider;

  bool isWriting = false;
  bool showEmojiPicker = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    didChangeDependencies();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sender = Provider.of<AuthProvider>(context, listen: false).userModel;
    _currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userModel.uid!;
    print('current userid $_currentUserId');
  }

  void pickImage({required ImageSource source}) async {
    File? selectedImage = await StorageMethods().pickImage(source: source);
    if (selectedImage != null) {
      storageMethods.uploadImage(
          image: selectedImage,
          receiverId: widget.receiver.uid!,
          senderId: _currentUserId,
          imageUploadProvider: _imageUploadProvider);
    }
  }

  Future<bool> requestCameraPermission() async {
    final serviceStatus = await Permission.camera.isGranted;

    final status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
      return true;
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      return false;
    } else {
      return false;
    }
  }

  Future<bool> requestPhotosPermission() async {
    final status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
      return true;
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      return false;
    } else {
      return false;
    }
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider =
        Provider.of<ImageUploadProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: const Color(0xFFE1E2E1),
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.loading
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15.w),
                  child: const CircularProgressIndicator())
              : Container(),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(_currentUserId)
          .collection(widget.receiver.uid!)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   _listScrollController.animateTo(
        //     _listScrollController.position.minScrollExtent,
        //     duration: Duration(milliseconds: 250),
        //     curve: Curves.easeInOut,
        //   );
        // });
        // print('I am here');
        return ListView.builder(
          reverse: true,
          controller: _listScrollController,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            // print(index);
            // print('why ? ${snapshot.data!.docs[index]}');
            if (snapshot.data != null) {
              // print(" this part");
              return chatMessageItem(snapshot.data!.docs[index]);
            } else {
              // print('i am here');
              return Center(
                child: Text(
                  "No messages are sent",
                  style: TextStyle(fontSize: 15.sp),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data() as Map<String, dynamic>);
    // print('message $_message');
    // print('I am in chatmessageitem');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10.r);

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalColors.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return (message.type != "image")
        ? Text(
            message.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          )
        : message.photoUrl != ""
            ? CachedImage(url: message.photoUrl)
            : Text(
                "Url was null",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              );
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10.r);

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalColors.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

//shows a bottom navigation sheet for the sender to be able to share media like photos/files/location ...etc
    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalColors.blackColor,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Row(
                    children: <Widget>[
                      MaterialButton(
                        child: Icon(
                          Icons.close,
                          size: 25.w,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          pickImage(source: ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        child: const ModalTile(
                          title: "Media",
                          subtitle: "Share Photos from gallery",
                          icon: Icons.image,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          pickImage(source: ImageSource.camera);
                          Navigator.pop(context);
                        },
                        child: const ModalTile(
                            title: "Camera",
                            subtitle: "Share Photos from camera",
                            icon: Icons.camera_alt),
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessage() async {
      var text = textFieldController.text;
      print(text);
      Message _message = Message(
          receiverId: widget.receiver.uid ?? "",
          senderId: sender!.uid ?? "",
          message: text,
          timestamp: Timestamp.now(),
          type: 'text',
          photoUrl: "");

      setState(() {
        isWriting = false;
      });
      textFieldController.clear();

      await ChatMethods().addMessageToDb(_message, sender!, widget.receiver);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
              decoration: const BoxDecoration(
                gradient: UniversalColors.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 25.w,
              ),
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  onChanged: (val) {
                    (val.isNotEmpty && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: const TextStyle(
                      color: UniversalColors.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.r),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    filled: true,
                    fillColor: UniversalColors.separatorColor,
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10.w),
                  decoration: const BoxDecoration(
                      gradient: UniversalColors.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15.w,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 25.w,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        widget.receiver.name != null
            ? widget.receiver.name![0].toUpperCase() +
                widget.receiver.name!.substring(1)
            : "No name",
      ),
      actions: const <Widget>[],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: UniversalColors.receiverColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: Icon(
            icon,
            color: UniversalColors.greyColor,
            size: 38.w,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalColors.greyColor,
            fontSize: 14.sp,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
