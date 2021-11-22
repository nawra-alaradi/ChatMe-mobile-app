import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:chat_me/constants.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color color;
  final void Function()? onPressed;
  final double? horizontalPadding, verticalPadding, fontSize;
  const MyElevatedButton(
      {Key? key,
      this.horizontalPadding,
      this.verticalPadding,
      this.fontSize,
      required this.text,
      required this.color,
      required this.onPressed,
      this.textColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: kButtonTextStyle.copyWith(
            fontSize: fontSize ?? 18.sp,
            color: textColor ?? const Color(0xffffffff).withOpacity(0.8)),
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: Colors.white,
        shadowColor: const Color(0x00000000).withOpacity(0.8),
        elevation: 10.r,
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 66.w,
            vertical: verticalPadding ?? 21.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            35.r,
          ),
        ),
      ),
    );
  }
}
