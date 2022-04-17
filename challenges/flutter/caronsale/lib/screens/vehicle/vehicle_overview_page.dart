import 'package:caronsale/constants/color_constants.dart';
import 'package:caronsale/constants/string_constants.dart';
import 'package:caronsale/models/vehicle_detail_model.dart';
import 'package:caronsale/screens/user/user_profile_page.dart';
import 'package:caronsale/screens/vehicle/vehicle_detail_page.dart';
import 'package:caronsale/widgets/avatar.dart';
import 'package:caronsale/widgets/vehicle_inspection_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VehicleOverviewPage extends StatefulWidget {
  const VehicleOverviewPage({Key? key}) : super(key: key);

  @override
  State<VehicleOverviewPage> createState() => _VehicleOverviewPageState();
}

class _VehicleOverviewPageState extends State<VehicleOverviewPage> {
  VehicleList _vehiclesListDataModel = VehicleList();
  String _profileUrl = '';

  @override
  void initState() {
    super.initState();
    _getVehiclesData();
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

  _getVehiclesData() {
    var vehiclesSnap = FirebaseFirestore.instance
        .collection('vehicles')
        .orderBy("date", descending: true)
        .snapshots();

    vehiclesSnap.listen((event) {
      _vehiclesListDataModel = VehicleList.fromSnapshotList(event.docs);
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
                        builder: (context) => const VehicleDetailPage()));
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
                _getAvatar(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _vehiclesListDataModel.vehicleList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VehicleDetailPage(
                                      vehicleDetailModel: _vehiclesListDataModel
                                          .vehicleList[index])),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: VehicleInspectionCard(
                                _vehiclesListDataModel.vehicleList[index]),
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

  _getAvatar() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserProfilePage(),
            ),
          );
        },
        child: Avatar(
          url: _profileUrl,
        ));
  }
}
