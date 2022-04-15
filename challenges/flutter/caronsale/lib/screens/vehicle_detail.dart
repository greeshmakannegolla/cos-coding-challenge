import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:caronsale/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';

import '../helpers/color_constants.dart';

class VehicleDetail extends StatefulWidget {
  const VehicleDetail({Key? key}) : super(key: key);

  @override
  State<VehicleDetail> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  late TextEditingController _vehicleMakeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleIdentificationNumberController;
  late TextEditingController _dateController;
  late DateTime _entryDate;

  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    _vehicleMakeController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _vehicleIdentificationNumberController = TextEditingController();
    _dateController = TextEditingController();
    _entryDate = DateTime.now();
  }

  @override
  void dispose() {
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleIdentificationNumberController.dispose();
    _dateController.dispose();
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _getFAB(context),
          body: Form(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: ColorConstants.kTextPrimaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text("Vehicle Detail",
                            style: kHeader.copyWith(fontSize: 22)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  buildInputFormFieldWithIcon(
                    context,
                    Row(
                      children: [
                        Text("DATE",
                            style: kInputformHeader.copyWith(fontSize: 14)),
                        getMandatoryStar()
                      ],
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: ColorConstants.kSecondaryTextColor,
                      size: 18,
                    ),
                    _dateController,
                    onTap: () async {
                      DateTime today = DateTime.now();
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(milliseconds: 100));
                      var date = await showRoundedDatePicker(
                        height: 300,
                        context: context,
                        initialDate: _entryDate,
                        firstDate:
                            today.subtract(const Duration(days: 365 * 10)),
                        lastDate: today.add(const Duration(days: 365 * 3)),
                        borderRadius: 16,
                        styleDatePicker: MaterialRoundedDatePickerStyle(
                            paddingMonthHeader: const EdgeInsets.all(12),
                            textStyleMonthYearHeader: TextStyle(
                                fontSize: 15,
                                color: ColorConstants.kTextPrimaryColor
                                    .withOpacity(0.8))),
                        theme: ThemeData(
                          primarySwatch: ColorConstants.kCalendarMaterialColor,
                          // ignore: deprecated_member_use
                          accentColor: ColorConstants.kSecondaryTextColor,
                        ),
                      );
                      if (date == null) {
                        return;
                      }

                      _entryDate = date;
                      var local = _entryDate.toLocal();

                      _dateController.text =
                          DateFormat(' d MMM, ' 'yy').format(local);

                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 23,
                  ),
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
                  const SizedBox(
                    height: 23,
                  ),
                  const Text(
                    'VEHICLE PHOTO',
                    style: kInputformHeader,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (imageFile == null)
                      ? InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            _showChoiceDialog(context);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 120,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorConstants.kFormBorderColor,
                                        width: 1,
                                      ),
                                      color:
                                          ColorConstants.kAppBackgroundColor),
                                ),
                              ),
                              const Icon(
                                Icons.add,
                                color: ColorConstants.kSecondaryTextColor,
                              )
                            ],
                          ))
                      : SizedBox(
                          height: 120,
                          width: 130,
                          child: Image(
                            image: FileImage(File(imageFile!.path)),
                            fit: BoxFit.fill,
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: ColorConstants.kSecondaryTextColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: ColorConstants.kSecondaryTextColor,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: ColorConstants.kSecondaryTextColor,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: ColorConstants.kSecondaryTextColor,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: ColorConstants.kSecondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = pickedFile;
    }
    setState(() {});

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      imageFile = pickedFile;
    }
    setState(() {});
    Navigator.pop(context);
  }
}

_getFAB(BuildContext context) {
  return TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(ColorConstants.kActionButtonColor),
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.95, 55)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 3),
        child: Text(
          "SAVE",
          style: kSubHeader.copyWith(color: ColorConstants.kTextPrimaryColor),
        ),
      ),
      onPressed: () {});
}
