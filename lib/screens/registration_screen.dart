import '../business_logic/providers/auth_provider.dart';
import 'package:chat_me/components/my_circular_progress_indicator.dart';
import 'package:chat_me/components/my_drop_down_button.dart';
import 'package:chat_me/components/my_elevated_button.dart';
import 'package:chat_me/components/my_text_form_field.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/extension_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final MyCircularProgressIndicator progressIndicator =
      MyCircularProgressIndicator();

  //global keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool isSignedIn = false;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    List<String> genders = ["Female", "Male"];
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
                  padding: EdgeInsets.only(left: 12.w),
                  child: SizedBox(
                    width: 255.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              size: 24.w,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        FittedBox(
                          child: Text(
                            'Register New User',
                            style: kRegistrationScreenTitle.copyWith(
                                fontSize: 24.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: MyTextFormField(
                    validator: (String? value) {
                      if (value == null) {
                        return null;
                      } else if (value.isEmpty) {
                        return 'This field is required*';
                      } else if (value.isValidName) {
                        return null;
                      } else {
                        return 'Invalid Name';
                      }
                    },
                    hintText: "Enter your name",
                    errorText: null,
                    labelText: 'Name',
                    textInputType: TextInputType.text,
                    maxLength: 30,
                    onChnaged: (String val) {},
                    onTap: () {},
                    icon: null,
                    controller: _nameController,
                    isObsecure: false,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: MyDropdownButton(
                    itemValueColor: Colors.white,
                    dropDownIconColor: Colors.white,
                    dropDownBackgroundColor: const Color(0xFFBDC3C7),
                    chosenItem: selectedGender,
                    hint: 'Select your gender',
                    itemsList: genders,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30.h,
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
                    hintText: "Enter your email",
                    errorText: null,
                    labelText: 'Email',
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
                  height: 30.h,
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
                  height: 73.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: MyElevatedButton(
                      text: 'Register',
                      color: const Color(0xFF000000).withOpacity(0.58),
                      onPressed: (_formKey.currentState != null &&
                              _formKey.currentState!.validate() &&
                              _isButtonEnabled)
                          ? () async {
                              //TODO: SIGN UP
                              progressIndicator.buildShowDialog(context);
                              String res = await Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .registerNewUser(
                                      _nameController.text,
                                      selectedGender!,
                                      // selectedDate,
                                      // _nationalityController.text,
                                      _emailController.text.toLowerCase(),
                                      _passwordController.text);
                              Navigator.pop(
                                  context); //remove circular progress indicator
                              if (res.compareTo(
                                      'Account with ${_emailController.text.toLowerCase()} has been successfully created. Please verify your email. Check your email inbox.') ==
                                  0) {
                                Navigator.popAndPushNamed(
                                    context, LoginScreen.id);
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    backgroundColor: const Color(0xFF726F9E),
                                    msg: res,
                                    fontSize: 14.sp,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5);
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
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }
}
