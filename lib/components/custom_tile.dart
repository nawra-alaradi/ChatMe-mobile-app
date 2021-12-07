import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? icon;
  final Widget? subtitle;
  final Widget? trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const CustomTile({
    Key? key,
    required this.leading,
    required this.title,
    this.icon,
    required this.subtitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.onTap,
    this.onLongPress,
    this.mini = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 60.h,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: mini ? 10.w : 0),
        margin: margin,
        child: FittedBox(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60.h,
                child: Row(
                  children: <Widget>[
                    leading,
                    SizedBox(
                      width: 15.w,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              title,
                              SizedBox(height: 5.h),
                              subtitle ?? Container(),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Divider(
                    thickness: 10.w,
                    color: Colors.black,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
