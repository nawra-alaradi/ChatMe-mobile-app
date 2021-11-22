import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_me/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextFormField extends StatelessWidget {
  final Function(String) onChnaged;
  final Function() onTap;
  final TextInputType? textInputType;
  final String? errorText, hintText, labelText;
  final int? maxLength;
  final IconData? icon;
  final TextEditingController? controller;
  final bool isObsecure;
  final String? Function(String?)? validator;
  final Color? textInputColor;

  const MyTextFormField(
      {Key? key,
      required this.hintText,
      required this.errorText,
      required this.labelText,
      required this.textInputType,
      required this.maxLength,
      required this.onChnaged,
      required this.onTap,
      required this.icon,
      required this.controller,
      required this.isObsecure,
      required this.validator,
      this.textInputColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      style: TextStyle(
          fontSize: 16.sp,
          //Todo: this has been changed from black to white
          color: textInputColor ?? Colors.white,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w400), //style the user input
      obscureText: isObsecure,
      controller: controller,
      onTap: onTap,
      onChanged: onChnaged,
      keyboardType: textInputType,
      decoration: InputDecoration(
        //fillColor: Colors.white,
        filled: false,
        //TODO: These three lines were added
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: textInputColor ?? Colors.white, width: 1.h),
        ),
        counterText: "", //hide maxi1mum number of characters
        errorText: errorText,
        errorStyle: kErrorTextStyle.copyWith(fontSize: 14.sp),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w400, //Work Sans light
          color: textInputColor ?? Colors.white,
        ),
        labelText: labelText,
        labelStyle: TextStyle(
            color: textInputColor ?? Colors.white,
            fontSize: 15.sp,
            fontFamily: 'Works Sans',
            fontWeight: FontWeight.w600),
        suffixIcon: Icon(icon),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        border: const OutlineInputBorder(),
      ),
      maxLength: maxLength,
    );
  }
}
