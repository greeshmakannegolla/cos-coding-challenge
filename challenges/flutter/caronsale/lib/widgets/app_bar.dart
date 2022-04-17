import 'package:caronsale/constants/color_constants.dart';
import 'package:caronsale/constants/style_constants.dart';
import 'package:flutter/material.dart';

class CosAppBar extends StatelessWidget {
  const CosAppBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: ColorConstants.kTextPrimaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: kHeader.copyWith(fontSize: 22)),
        ),
      ],
    );
  }
}
