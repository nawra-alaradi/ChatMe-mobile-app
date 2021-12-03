import 'package:chat_me/constants.dart';
import 'package:chat_me/screens/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuietBox extends StatelessWidget {
  const QuietBox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Container(
          color: const Color(0xff272c35),
          padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 25.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "This is where all the contacts are listed",
                textAlign: TextAlign.center,
                style: kBodyTextStyle.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 25.h),
              Text(
                  "Search for your friends and family to start calling or chatting with them",
                  textAlign: TextAlign.center,
                  style: kBodyTextStyle.copyWith(
                      fontSize: 18.sp,
                      letterSpacing: 1.2.sp,
                      fontWeight: FontWeight.normal)),
              SizedBox(height: 25.h),
              TextButton(
                  child: Text(
                    "START SEARCHING",
                    style: kBodyTextStyle.copyWith(fontSize: 16.sp),
                  ),
                  onPressed: () => Navigator.pushNamed(
                      context, SearchScreen.id) //it is search screen
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
// TextStyle(
// letterSpacing: 1.2,
// fontWeight: FontWeight.normal,
// fontSize: 18,
// ),
