import 'package:flutter/material.dart';
import 'package:chat_me/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const MyTextButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var width = getWidth(context);
    return Align(
      alignment: Alignment.topLeft,
      child: TextButton(
        child: Text(
          text,
          style: kSmallText.copyWith(fontSize: 15.sp),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
