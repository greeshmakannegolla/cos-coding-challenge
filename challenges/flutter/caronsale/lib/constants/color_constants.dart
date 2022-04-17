import 'package:flutter/material.dart';

class ColorConstants {
  static const kTextPrimaryColor = Colors.black;
  static const kSecondaryTextColor = Color(0xFF657381);
  static const kAppBackgroundColor = Colors.white;
  static const kActionButtonColor = Color(0xFFffd452);
  static const kLoginBackgroundColor = Color(0xFF474b57);
  static const kFormBorderColor = Color(0xFFE8EAED);
  static const kFormTextFieldColor = Color(0xFFFDFDFD);
  static const kFormTextHeaderColor = Color(0xFF657381);
  static const kMandatoryStarColor = Colors.red;

  static Map<int, Color> kCalendarSwatchColor = {
    50: const Color.fromRGBO(101, 115, 129, .1),
    100: const Color.fromRGBO(101, 115, 129, .2),
    200: const Color.fromRGBO(101, 115, 129, .3),
    300: const Color.fromRGBO(101, 115, 129, .4),
    400: const Color.fromRGBO(101, 115, 129, .5),
    500: const Color.fromRGBO(101, 115, 129, .6),
    600: const Color.fromRGBO(101, 115, 129, .7),
    700: const Color.fromRGBO(101, 115, 129, .8),
    800: const Color.fromRGBO(101, 115, 129, .9),
    900: const Color.fromRGBO(101, 115, 129, 1),
  };

  static MaterialColor kCalendarMaterialColor =
      MaterialColor(0xFF657381, kCalendarSwatchColor);
}
