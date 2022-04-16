import 'package:caronsale/screens/user_profile.dart';
import 'package:caronsale/screens/vehicle_detail.dart';
import 'package:caronsale/screens/vehicle_inspection_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/color_constants.dart';
import '../models/vehicle_detail_model.dart';

class VehicleInspectionList extends StatefulWidget {
  const VehicleInspectionList({Key? key}) : super(key: key);

  @override
  State<VehicleInspectionList> createState() => _VehicleInspectionListState();
}

class _VehicleInspectionListState extends State<VehicleInspectionList> {
  VehicleList vehiclesListDataModel = VehicleList();

  @override
  void initState() {
    super.initState();
    var vehiclesSnap =
        FirebaseFirestore.instance.collection('vehicles').snapshots();

    vehiclesSnap.listen((event) {
      vehiclesListDataModel = VehicleList.fromSnapshotList(event.docs);
      setState(() {});
    });
  }

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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserProfile(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    // backgroundImage: CachedNetworkImageProvider(
                    //     Global.currentUser.imageUrl),
                    backgroundColor: Colors.blue,
                    radius: 28,
                    // : CircleAvatar(
                    //     backgroundColor: ColorConstants.buttonColor,
                    //     child: Text(
                    //       Global.currentUser.firstName[0] +
                    //           Global.currentUser.lastName[0],
                    //       style: buttonStyle.copyWith(
                    //         fontSize: 12,
                    //       ),
                    //     ),
                    //   ), //TODO: Add this if no user profile image
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: vehiclesListDataModel.vehicleList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VehicleDetail(
                                      vehicleDetailModel: vehiclesListDataModel
                                          .vehicleList[index])),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: VehicleInspectionCard(
                                vehiclesListDataModel.vehicleList[index]),
                          ));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
