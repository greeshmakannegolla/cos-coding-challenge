import 'package:caronsale/helpers/string_constants.dart';
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
  String _profileUrl = '';

  @override
  void initState() {
    super.initState();
    _getSnapshotData();
    _getProfilePicture();
  }

  _getProfilePicture() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(kEmail)
        .snapshots()
        .listen((event) {
      _profileUrl = event.data()?['profileUrl'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  _getSnapshotData() {
    var vehiclesSnap = FirebaseFirestore.instance
        .collection('vehicles')
        .orderBy("date", descending: true)
        .snapshots();

    vehiclesSnap.listen((event) {
      vehiclesListDataModel = VehicleList.fromSnapshotList(event.docs);
      if (mounted) {
        setState(() {});
      }
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
          backgroundColor: ColorConstants.kFormBorderColor,
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
                  child: (_profileUrl.isEmpty)
                      ? CircleAvatar(
                          radius: 28,
                          backgroundColor: ColorConstants.kSecondaryTextColor,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: const Icon(
                                Icons.person,
                                size: 28,
                              )),
                        )
                      : CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(_profileUrl),
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
