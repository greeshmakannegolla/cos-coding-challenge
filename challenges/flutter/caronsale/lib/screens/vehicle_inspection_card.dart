import 'package:caronsale/helpers/string_constants.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:flutter/material.dart';

class VehicleInspectionCard extends StatefulWidget {
  const VehicleInspectionCard({Key? key}) : super(key: key);

  @override
  State<VehicleInspectionCard> createState() => _VehicleInspectionCardState();
}

class _VehicleInspectionCardState extends State<VehicleInspectionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 15.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            child: SizedBox(
              height: 230,
              width: double.infinity,
              child: Image.asset(kDefaultVehicle,
                  fit: BoxFit.fill), //TODO: fETCH imageURL FROM FIREBASE
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: _getRestaurantInfo(),
          ),
        ],
      ),
    );
  }

  Column _getRestaurantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 5.5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "ASD234569890GHJJK99", //TODO: fETCH vin FROM FIREBASE
                  style: kHeader,
                ),
                Text('15 Apr, 2022',
                    style: kSecondaryHeader) //TODO: fETCH date FROM FIREBASE
              ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("German make",
                style:
                    kSecondaryHeader), //TODO: fETCH make FROM FIREBASE - Add row conditionally
            Text("Q12",
                style:
                    kSecondaryHeader) //TODO: fETCH model FROM FIREBASE - Add row conditionally
          ],
        ),
        const SizedBox(
          height: 5.5,
        ),
      ],
    );
  }
}
