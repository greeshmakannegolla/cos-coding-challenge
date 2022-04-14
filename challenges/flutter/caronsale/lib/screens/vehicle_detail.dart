import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:caronsale/helpers/validator.dart';
import 'package:flutter/material.dart';

class VehicleDetail extends StatefulWidget {
  const VehicleDetail({Key? key}) : super(key: key);

  @override
  State<VehicleDetail> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  late TextEditingController _vehicleMakeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleIdentificationNumberController;

  @override
  void initState() {
    super.initState();
    _vehicleMakeController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _vehicleIdentificationNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleIdentificationNumberController.dispose();
    super.dispose();
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
          body: Form(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildInputFormField(
                      context,
                      Row(
                        children: [
                          const Text(
                            'VEHICLE IDENTIFICATION NUMBER',
                            style: kInputformHeader,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          getMandatoryStar(),
                        ],
                      ), (newText) {
                    // _company.bankDetail.name = newText; //TODO: Set to right param
                  }, _vehicleIdentificationNumberController,
                      TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: Validator.validateVin),
                  const SizedBox(
                    height: 23,
                  ),
                  buildInputFormField(
                    context,
                    const Text(
                      'VEHICLE MAKE',
                      style: kInputformHeader,
                    ),
                    (newText) {
                      // _company.bankDetail.name = newText; //TODO: Set to right param
                    },
                    _vehicleMakeController,
                    TextInputAction.next,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  buildInputFormField(
                    context,
                    const Text(
                      'VEHICLE MODEL',
                      style: kInputformHeader,
                    ),
                    (newText) {
                      // _company.bankDetail.name = newText; //TODO: Set to right param
                    },
                    _vehicleModelController,
                    TextInputAction.done,
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
