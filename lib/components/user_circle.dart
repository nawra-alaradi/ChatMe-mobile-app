import 'package:chat_me/business_logic/initials_extractor.dart';
import 'package:chat_me/business_logic/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../universa_variables.dart';

class UserCircle extends StatelessWidget {
  const UserCircle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthProvider userProvider = Provider.of<AuthProvider>(context);

    return Container(
      height: 35.h,
      width: 35.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: const Color(0xff272c35), //seperator color
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              Utils.getInitials(userProvider.userModel.name!.toUpperCase()),
              style: TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: UniversalVariables.blackColor, width: 2),
                  color: UniversalVariables.onlineDotColor),
            ),
          )
        ],
      ),
    );
  }
}
