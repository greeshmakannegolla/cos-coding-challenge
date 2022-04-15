import 'package:caronsale/screens/vehicle_detail.dart';
import 'package:caronsale/screens/vehicle_inspection_card.dart';
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 28),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MyProfileScreen(),
                      //   ),
                      // );
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: 15, //TODO: Change to list length
                    itemBuilder: (BuildContext ctx, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        child: InkWell(
                            onTap: () {
                              //Navigation to the selected vehical inspection
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           RestaurantDetailScreen(
                              //               _filteredRestaurantList[
                              //                   index])),
                              // );
                            },
                            child:
                                const VehicleInspectionCard() //TODO: Change to selected card
                            // (
                            // _filteredRestaurantList[index],
                            // key: UniqueKey(),
                            //)
                            ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
