import 'package:caronsale/screens/vehicle_detail.dart';
import 'package:flutter/material.dart';

import '../helpers/color_constants.dart';

class VehicleInspectionList extends StatefulWidget {
  const VehicleInspectionList({Key? key}) : super(key: key);

  @override
  State<VehicleInspectionList> createState() => _VehicleInspectionListState();
}

class _VehicleInspectionListState extends State<VehicleInspectionList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VehicleDetail()));
              },
              backgroundColor: ColorConstants.kLoginBackgroundColor,
              child: const Icon(
                Icons.add,
                color: ColorConstants.kAppBackgroundColor,
              ),
            ),
          ),
          backgroundColor: ColorConstants.kAppBackgroundColor,
          body: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
