import 'package:caronsale/helpers/color_constants.dart';
import 'package:flutter/material.dart';

const kHeader = TextStyle(
  fontFamily: "Sen",
  fontWeight: FontWeight.bold,
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 41,
);

const kSubText = TextStyle(
  fontFamily: "Sen",
  fontWeight: FontWeight.w600,
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 21,
);

const kSubHeader = TextStyle(
  fontFamily: "Sen",
  fontWeight: FontWeight.w600,
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 18,
);

const kData = TextStyle(
  fontFamily: "Sen",
  fontWeight: FontWeight.w400,
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 17,
);

const kCalendarMonthStyle = TextStyle(
    fontFamily: "Sen", fontSize: 15, color: ColorConstants.kTextPrimaryColor);

const kLoginTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: ColorConstants.kAppBackgroundColor,
  hintStyle: TextStyle(
      color: ColorConstants.kSecondaryTextColor, fontWeight: FontWeight.w400),
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: ColorConstants.kAppBackgroundColor, width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(7.33),
    ),
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
  border: OutlineInputBorder(
    borderSide:
        BorderSide(color: ColorConstants.kAppBackgroundColor, width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(7.33),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: ColorConstants.kAppBackgroundColor, width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(7.33),
    ),
  ),
);

const kLoginTextFieldStyle = TextStyle(
  color: ColorConstants.kTextPrimaryColor,
  fontSize: 14.66,
  fontFamily: "Sen",
  fontWeight: FontWeight.w400,
);

const kLoginTextTitleStyle = TextStyle(
  color: ColorConstants.kAppBackgroundColor,
  fontSize: 12.88,
  fontWeight: FontWeight.w700,
  fontFamily: "Sen",
);
