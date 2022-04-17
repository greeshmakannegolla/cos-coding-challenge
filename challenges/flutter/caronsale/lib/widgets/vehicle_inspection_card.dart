import 'package:caronsale/constants/string_constants.dart';
import 'package:caronsale/constants/style_constants.dart';
import 'package:caronsale/models/vehicle_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleInspectionCard extends StatefulWidget {
  final VehicleDetailModel vehicleDetailModel;
  const VehicleInspectionCard(this.vehicleDetailModel, {Key? key})
      : super(key: key);

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
              child: widget.vehicleDetailModel.vehiclePhotoUrl.isEmpty
                  ? Image.asset(kDefaultVehicle, fit: BoxFit.fill)
                  : Image.network(widget.vehicleDetailModel.vehiclePhotoUrl,
                      fit: BoxFit.fill),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: _getVehicleInfo(),
          ),
        ],
      ),
    );
  }

  Column _getVehicleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 5.5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              widget.vehicleDetailModel.vin,
              style: kHeader,
            ),
            Text(
                DateFormat("dd MMM, yyyy")
                    .format(widget.vehicleDetailModel.date),
                style: kSecondaryHeader)
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.vehicleDetailModel.vehicleMake.isNotEmpty
                ? Text(widget.vehicleDetailModel.vehicleMake,
                    style: kSecondaryHeader)
                : Container(),
            widget.vehicleDetailModel.vehicleModel.isNotEmpty
                ? Text(widget.vehicleDetailModel.vehicleModel,
                    style: kSecondaryHeader)
                : Container()
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
