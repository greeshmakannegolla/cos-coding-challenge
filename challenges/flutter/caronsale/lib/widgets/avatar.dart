import 'package:caronsale/constants/color_constants.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.url,
    this.radius = 28,
  }) : super(key: key);

  final String? url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return (url != null && url!.isNotEmpty)
        ? CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(
              url!,
            ),
          )
        : CircleAvatar(
            radius: radius,
            backgroundColor: ColorConstants.kSecondaryTextColor,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Icon(
                  Icons.person,
                  size: radius,
                )),
          );
  }
}
