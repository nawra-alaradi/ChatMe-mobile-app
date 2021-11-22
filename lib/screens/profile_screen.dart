import 'package:chat_me/business_logic/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_me/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_me/screens/welcome_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'ProfileScreen';
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Todo: Obtain user name
    String? userName =
        Provider.of<AuthProvider>(context, listen: true).userModel.name;
    String? emailAddress =
        Provider.of<AuthProvider>(context, listen: true).userModel.email;
    String? gender =
        Provider.of<AuthProvider>(context, listen: true).userModel.gender;

    return Scaffold(
      backgroundColor: const Color(0xFFE1E2E1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: kAppBarTextStyle.copyWith(fontSize: 20.sp),
          title: Text(
            'Profile',
            style: kAppBarTextStyle.copyWith(fontSize: 20.sp),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: IconButton(
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signOut();
                    Navigator.pushNamed(context, WelcomeScreen.id);
                    Fluttertoast.showToast(
                        backgroundColor: const Color(0xFF726F9E),
                        msg: "Signed out successfully",
                        fontSize: 14.sp,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1);
                  },
                  icon: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 18.w,
                  ),
                )),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 82.w, vertical: 35.h),
              child: CircleAvatar(
                backgroundColor: const Color(0xFFFFAB00),
                radius: 196.w,
                child: Center(
                  child: FittedBox(
                    //TODO: Obtain first character of dr name from doctor object upon sign in
                    child: Text(
                      userName![0].toUpperCase(),
                      style: kCircleAvatarTextStyle.copyWith(fontSize: 150.sp),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              'Name: ${userName[0].toUpperCase() + userName.substring(1)}',
              style: kDropdownItemTextStyle.copyWith(
                  fontSize: 18.sp, color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              'Gender: $gender',
              style: kDropdownItemTextStyle.copyWith(
                  fontSize: 18.sp, color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 100.h),
            child: Text(
              'Email address: $emailAddress',
              style: kDropdownItemTextStyle.copyWith(
                  fontSize: 18.sp, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
