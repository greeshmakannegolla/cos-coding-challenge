import 'package:caronsale/constants/color_constants.dart';
import 'package:caronsale/constants/style_constants.dart';
import 'package:flutter/material.dart';

class CosTextButton extends StatelessWidget {
  const CosTextButton({required this.onPressed, required this.title, Key? key})
      : super(key: key);

  final void Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorConstants.kActionButtonColor),
            fixedSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width * 0.95, 55)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 3),
          child: Text(
            title,
            style: kSubHeader.copyWith(color: ColorConstants.kTextPrimaryColor),
          ),
        ),
        onPressed: onPressed);
  }
}
