import 'package:caronsale/constants/color_constants.dart';
import 'package:caronsale/constants/style_constants.dart';
import 'package:caronsale/widgets/mandatory_star.dart';
import 'package:flutter/material.dart';

class CosTextField extends StatelessWidget {
  const CosTextField({
    required this.title,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.showAsMandatory = false,
    this.maxLength,
    this.readOnly = false,
    this.decoration = kTextFieldDecoration,
    Key? key,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool showAsMandatory;
  final bool readOnly;
  final int? maxLength;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              title,
              style: kInputformHeader,
            ),
            showAsMandatory ? const MandatoryStar() : Container()
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          maxLength: maxLength,
          textInputAction: textInputAction,
          controller: controller,
          keyboardType: textInputType,
          cursorColor: ColorConstants.kTextPrimaryColor,
          decoration: decoration,
          style: kTextFieldStyle,
          textAlignVertical: TextAlignVertical.center,
          validator: validator,
          autocorrect: false,
          readOnly: readOnly,
        ),
      ],
    );
  }
}
