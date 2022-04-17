import 'package:caronsale/helpers/color_constants.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:caronsale/helpers/validator.dart';
import 'package:flutter/material.dart';

class CosPasswordField extends StatefulWidget {
  const CosPasswordField(
      {required this.title,
      required this.controller,
      this.textInputAction = TextInputAction.done,
      Key? key})
      : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputAction textInputAction;

  @override
  State<CosPasswordField> createState() => _CosPasswordFieldState();
}

class _CosPasswordFieldState extends State<CosPasswordField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: kLoginTextTitleStyle,
        ),
        const SizedBox(height: 10),
        TextFormField(
          textInputAction: widget.textInputAction,
          controller: widget.controller,
          keyboardType: TextInputType.text,
          obscureText: hidePassword,
          cursorColor: ColorConstants.kTextPrimaryColor,
          decoration: kTextFieldDecoration.copyWith(
            suffixIcon: IconButton(
              icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off,
                  color: ColorConstants.kTextPrimaryColor),
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
            ),
          ),
          style: kTextFieldStyle,
          textAlignVertical: TextAlignVertical.center,
          validator: Validator.validatePassword,
          autocorrect: false,
        ),
      ],
    );
  }
}
