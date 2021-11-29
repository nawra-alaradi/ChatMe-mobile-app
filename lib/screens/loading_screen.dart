import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingScreen extends StatelessWidget {
  static const String id = "LoadingScreen";
  const LoadingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/cool-background.png'),
                fit: BoxFit.cover),
          ),
          child: ListView(
            children: [
              Center(
                child: Image.asset(
                  'images/chat-bubble.png',
                  width: 279.w,
                  height: 279.h,
                ),
              ),
              Center(
                child: Container(
                    height: 25.h,
                    width: 25.w,
                    child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
