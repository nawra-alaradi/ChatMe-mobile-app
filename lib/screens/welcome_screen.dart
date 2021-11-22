import 'package:chat_me/components/my_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_me/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_me/screens/login_screen.dart';
import 'package:chat_me/screens/registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'WelcomeScreen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            //Container used to fill a background screen image
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/cool-background.png'),
                  fit: BoxFit.cover),
            ),
            child: ListView(
              padding: EdgeInsets.only(top: 32.h, bottom: 53.h),
              children: [
                Image.asset(
                  'images/chat-bubble.png',
                  width: 279.w,
                  height: 279.h,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'CHATME',
                        textStyle: kAppNameTextStyle.copyWith(
                            fontSize: 28.sp,
                            color: Colors.white.withOpacity(0.75)),
                        // Change this to make it faster or slower
                        speed: const Duration(milliseconds: 290),
                      ),
                    ],
                    // You could replace repeatForever to a fixed number of repeats
                    // with totalRepeatCount: X, where X is the repeats you want.
                    repeatForever: true,
                  ),
                ),
                SizedBox(
                  height: 31.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 39.w),
                  child: MyElevatedButton(
                      text: 'Sign in',
                      color: const Color(0xFF000000).withOpacity(0.58),
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      }),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 165.w),
                  child: Text(
                    "OR",
                    style: kButtonTextStyle.copyWith(fontSize: 20.sp),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 39.w),
                  child: MyElevatedButton(
                      text: 'Sign up',
                      color: const Color(0xFF000000).withOpacity(0.58),
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
