import 'package:caronsale/helpers/color_constants.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildInputFormFieldWithIcon(
  context,
  Widget title,
  Widget suffixImage,
  TextEditingController controller, {
  void Function(String)? onChanged,
  void Function()? onTap,
}) {
  //Function onTap
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      title,
      const SizedBox(height: 10),
      TextFormField(
        readOnly: true,
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        cursorColor: ColorConstants.kTextPrimaryColor,
        decoration: kFormFieldDecoration.copyWith(suffixIcon: suffixImage),
        style: const TextStyle(
          color: ColorConstants.kTextPrimaryColor,
          fontSize: 14.66,
          fontFamily: "Sen",
          fontWeight: FontWeight.w400,
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    ],
  );
}

Widget buildInputFormField(
    context,
    Widget title,
    void Function(String text) onTextChange,
    // bool isPasswordField,
    TextEditingController? controller,
    TextInputAction textInputAction,
    {String? Function(String?)? validator,
    InputDecoration decoration = kFormFieldDecoration,
    int maxLines = 1,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? textInputFormatter}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      title,
      const SizedBox(height: 10),
      TextFormField(
        maxLines: maxLines,
        obscureText: obscureText,
        inputFormatters: textInputFormatter,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        readOnly: readOnly,
        showCursor: readOnly ? false : true,
        controller: controller,
        onChanged: onTextChange,
        cursorColor: ColorConstants.kTextPrimaryColor,
        validator: validator,
        decoration: decoration,
        style: kTextFieldContent,
        textAlignVertical: TextAlignVertical.center,
      ),
    ],
  );
}

Widget getMandatoryStar() {
  return IntrinsicHeight(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        Text(
          "*",
          style: TextStyle(
              color: ColorConstants.kMandatoryStarColor, fontSize: 20),
        ),
      ],
    ),
  );
}

showAlertDialog(BuildContext context, String title, String content) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
