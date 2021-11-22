import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

const kBodyTextStyle = TextStyle(
  fontSize: 18, fontFamily: 'Work Sans',
  fontWeight: FontWeight.w400, //Work sans regular
  color: Colors.black,
);

const kAppNameTextStyle = TextStyle(
    fontFamily: 'Works Sans',
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontSize: 24);

TextStyle kButtonTextStyle = TextStyle(
    //changed from const to TextStyle due to opacity variation
    color: const Color(0xffffffff).withOpacity(0.8),
    fontSize: 24,
    fontFamily: 'Judson',
    fontWeight: FontWeight.w700);

const kErrorTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Work Sans');

const kRegistrationScreenTitle = TextStyle(
    fontFamily: 'Works Sans',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: Colors.white);

const kDropdownItemTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Work Sans',
    fontWeight: FontWeight.w400,
    color: Colors.white);

const kDropdownHintTextStyle = TextStyle(
  fontFamily: 'Work Sans',
  fontSize: 14,
  fontWeight: FontWeight.w300,
  color: Colors.black,
);

const kListTileTitle = TextStyle(
  fontSize: 14,
  fontFamily: 'Work Sans',
  fontWeight: FontWeight.w600, //Work sans semi-bold
  color: Color(0xFF030303),
);

const kSmallText = TextStyle(
    color: Color(0xFF0D47A1),
    fontWeight: FontWeight.w600,
    fontFamily: 'Works Sans',
    fontSize: 14);
const kAppBarTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Works Sans',
    color: Colors.white);

const kDashboardTextStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Judson',
    fontWeight: FontWeight.w700,
    color: Colors.black);

const kCircleAvatarTextStyle = TextStyle(
  fontSize: 150, fontFamily: 'Work Sans',
  fontWeight: FontWeight.w600, //Work sans semi-bold
  color: Colors.white,
);
const kSnackbarTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'Judson',
    fontWeight: FontWeight.w400);
