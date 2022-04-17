import 'package:caronsale/helpers/color_constants.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:caronsale/helpers/widgets/mandatory_star.dart';
import 'package:flutter/material.dart';

class CosTextField extends StatelessWidget {
  const CosTextField(
      {required this.title,
      required this.controller,
      this.textInputType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.validator,
      this.showAsMandatory = false,
      this.maxLength,
      Key? key})
      : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool showAsMandatory;

  final int? maxLength;

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
          decoration: kTextFieldDecoration,
          style: kTextFieldStyle,
          textAlignVertical: TextAlignVertical.center,
          validator: validator,
          autocorrect: false,
        ),
      ],
    );
  }
}
