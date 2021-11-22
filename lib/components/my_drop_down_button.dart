import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_me/constants.dart';

class MyDropdownButton extends StatelessWidget {
  final void Function(String?) onChanged;
  final String? chosenItem;
  final String hint;
  final List<String> itemsList;
  final Color dropDownIconColor;
  final Color itemValueColor;
  final Color dropDownBackgroundColor;
  const MyDropdownButton(
      {Key? key,
      required this.chosenItem,
      required this.hint,
      required this.itemsList,
      required this.onChanged,
      required this.dropDownIconColor,
      required this.itemValueColor,
      required this.dropDownBackgroundColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w), // padding for the text inside the dropdown menu
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.w),
          borderRadius: BorderRadius.circular(10.r)),
      child: DropdownButton(
        value: chosenItem,
        onChanged: onChanged,
        items: itemsList.map<DropdownMenuItem<String>>((String itemValue) {
          return DropdownMenuItem<String>(
              value: itemValue,
              child: Text(
                itemValue,
                style: TextStyle(color: itemValueColor),
              ));
        }).toList(),
        hint: Text(
          hint,
          style: kDropdownHintTextStyle.copyWith(
              fontSize: 14.sp, color: dropDownIconColor),
        ),
        dropdownColor: dropDownBackgroundColor,
        icon: Icon(
          Icons.arrow_drop_down,
          color: dropDownIconColor,
          size: 26.w,
        ),
        iconSize: 25.w,
        isExpanded: true,
        underline: const SizedBox(),
        style: kDropdownItemTextStyle.copyWith(fontSize: 14.sp),
      ),
    );
  }
}
