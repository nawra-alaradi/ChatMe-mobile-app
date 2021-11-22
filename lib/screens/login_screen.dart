import 'package:chat_me/business_logic/auth_provider.dart';
import 'package:chat_me/components/my_circular_progress_indicator.dart';
import 'package:chat_me/components/my_elevated_button.dart';
import 'package:chat_me/components/my_text_button.dart';
import 'package:chat_me/components/my_text_form_field.dart';
import 'package:chat_me/extension_class.dart';
import 'package:chat_me/screens/registration_screen.dart';
import 'package:chat_me/screens/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'email_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final MyCircularProgressIndicator progressIndicator =
      MyCircularProgressIndicator();

  //global keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool isSignedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          //Container used to fill a background screen image
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/cool-background.png'),
                fit: BoxFit.cover),
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              if (_formKey.currentState != null) {
                setState(() {
                  _isButtonEnabled = _formKey.currentState!.validate();
                });
              }
            },
            child: ListView(
              padding: EdgeInsets.only(top: 17.h, bottom: 53.h),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 23.w),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 25.h,
                        ),
                      )),
                ),
                Image.asset(
                  'images/chat-bubble.png',
                  width: 136.w,
                  height: 148.h,
                ),
                SizedBox(
                  height: 23.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: MyTextFormField(
                    validator: (String? value) {
                      if (value == null) {
                        return null;
                      } else if (value.isEmpty) {
                        return 'This field is required*';
                      } else if (value.isValidEmail) {
                        return null;
                      } else {
                        return 'Invalid email address';
                      }
                    },
                    hintText: "Enter your email address",
                    errorText: null,
                    labelText: 'Email address',
                    textInputType: TextInputType.emailAddress,
                    maxLength: 45,
                    onChnaged: (String val) {},
                    onTap: () {},
                    icon: null,
                    controller: _emailController,
                    isObsecure: false,
                  ),
                ),
                SizedBox(
                  height: 73.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: MyTextFormField(
                    validator: (String? value) {
                      if (value == null) {
                        return null;
                      } else if (value.isEmpty) {
                        return 'This field is required*';
                      } else if (value.isValidPassword) {
                        return null;
                      } else {
                        return 'Invalid password';
                      }
                    },
                    hintText: "Enter your password",
                    errorText: null,
                    labelText: 'Password',
                    textInputType: TextInputType.text,
                    maxLength: 12,
                    onChnaged: (String val) {},
                    onTap: () {},
                    icon: null,
                    controller: _passwordController,
                    isObsecure: true,
                  ),
                ),
                SizedBox(
                  height: 29.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27.w),
                  child: MyTextButton(
                    text: 'Forgot your password?',
                    onPressed: () {
                      Navigator.pushNamed(context, EmailScreen.id);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27.w),
                  child: MyTextButton(
                    text: 'New user? Register',
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: MyElevatedButton(
                      text: 'Log in',
                      color: const Color(0xFF000000).withOpacity(0.58),
                      onPressed: (_formKey.currentState != null &&
                              _formKey.currentState!.validate() &&
                              _isButtonEnabled)
                          ? () async {
                              progressIndicator.buildShowDialog(context);
                              String res = await Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .chatUserSignIn(_emailController.text,
                                      _passwordController.text);
                              Navigator.of(context).pop();
                              if (res.compareTo('signed in successfully') ==
                                  0) {
                                Navigator.pushNamed(context, RouteScreen.id);
                                Fluttertoast.showToast(
                                    backgroundColor: const Color(0xFF726F9E),
                                    msg: 'Signed in successfully',
                                    fontSize: 14.sp,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1);
                              } else {
                                Fluttertoast.showToast(
                                    backgroundColor: const Color(0xFF726F9E),
                                    msg: res,
                                    fontSize: 14.sp,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1);
                              }
                            }
                          : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
