import 'package:caronsale/constants/color_constants.dart';
import 'package:flutter/material.dart';

class MandatoryStar extends StatelessWidget {
  const MandatoryStar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
