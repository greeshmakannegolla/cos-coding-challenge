import 'package:caronsale/constants/color_constants.dart';
import 'package:flutter/material.dart';

const kSubHeader = TextStyle(
  fontFamily: "Sen",
  fontWeight: FontWeight.w600,
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 18,
);

const kCalendarMonthStyle = TextStyle(
    fontFamily: "Sen", fontSize: 15, color: ColorConstants.kTextPrimaryColor);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: ColorConstants.kFormTextFieldColor,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorConstants.kFormBorderColor, width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(7.33),
    ),
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: ColorConstants.kFormBorderColor, width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(7.33),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorConstants.kFormBorderColor, width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(7.33),
    ),
  ),
);

const kTextFieldStyle = TextStyle(
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 14.66,
  fontFamily: "Sen",
  fontWeight: FontWeight.w400,
);

const kInputformHeader = TextStyle(
  color: ColorConstants.kFormTextHeaderColor,
  fontWeight: FontWeight.w700,
  fontSize: 14,
  fontFamily: "Sen",
);

const kHeader = TextStyle(
  fontFamily: "Sen",
  fontWeight: FontWeight.w700,
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 18,
);

const kSecondaryHeader = TextStyle(
  fontFamily: "Sen",
  fontWeight: FontWeight.w400,
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 15,
);

const kUnderlineHeader = TextStyle(
  fontFamily: "Sen",
  fontWeight: FontWeight.w600,
  color: Colors.blue,
  fontSize: 18,
  decoration: TextDecoration.underline,
);
