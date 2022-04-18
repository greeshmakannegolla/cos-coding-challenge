import 'package:caronsale/constants/color_constants.dart';
import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/constants/style_constants.dart';
import 'package:caronsale/helpers/validator.dart';
import 'package:caronsale/widgets/app_bar.dart';
import 'package:caronsale/widgets/mandatory_star.dart';
import 'package:caronsale/widgets/text_button.dart';
import 'package:caronsale/widgets/text_field.dart';
import 'package:caronsale/models/vehicle_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cached_network_image/cached_network_image.dart';

class VehicleDetailPage extends StatefulWidget {
  final VehicleDetailModel? vehicleDetailModel;
  const VehicleDetailPage({Key? key, this.vehicleDetailModel})
      : super(key: key);

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vinController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _entryDate = DateTime.now();

  final _vehicleDetailModel = VehicleDetailModel();

  XFile? _imageFile;
  String _vehicleUrl = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.vehicleDetailModel != null) {
      _vehicleMakeController.text = widget.vehicleDetailModel!.vehicleMake;
      _vehicleModelController.text = widget.vehicleDetailModel!.vehicleModel;
      _vinController.text = widget.vehicleDetailModel!.vin;
      _dateController.text =
          DateFormat(' d MMM, ' 'yy').format(widget.vehicleDetailModel!.date);
      _entryDate = widget.vehicleDetailModel!.date;
      _vehicleUrl = widget.vehicleDetailModel!.vehiclePhotoUrl;
    }
  }

  @override
  void dispose() {
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vinController.dispose();
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
          floatingActionButton:
              CosTextButton(onPressed: _onSavePressed, title: 'SAVE'),
          body: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CosAppBar(title: "Vehicle Detail"),
                    const SizedBox(
                      height: 50,
                    ),
                    buildInputFormFieldWithIcon(
                        context,
                        Row(
                          children: const [
                            Text("DATE", style: kInputformHeader),
                            MandatoryStar(),
                          ],
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: ColorConstants.kSecondaryTextColor,
                          size: 18,
                        ),
                        _dateController,
                        onTap: _onCalendarPressed),
                    const SizedBox(
                      height: 23,
                    ),
                    CosTextField(
                      title: 'VEHICLE IDENTIFICATION NUMBER',
                      controller: _vinController,
                      showAsMandatory: true,
                      textInputAction: TextInputAction.next,
                      validator: Validator.validateVin,
                      maxLength: 17,
                      readOnly: _vinController.text.isNotEmpty ? true : false,
                      decoration: _vinController.text.isEmpty
                          ? kTextFieldDecoration
                          : kTextFieldDecoration.copyWith(
                              fillColor: ColorConstants.kSecondaryTextColor
                                  .withOpacity(0.2)),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    CosTextField(
                      title: 'VEHICLE MAKE',
                      controller: _vehicleMakeController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    CosTextField(
                      title: 'VEHICLE MODEL',
                      controller: _vehicleModelController,
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
                    _getVehicleImage(context),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getVehicleImage(BuildContext context) {
    if (_vehicleUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: _vehicleUrl,
        height: 230,
        width: double.infinity,
        fit: BoxFit.fill,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }

    if (_imageFile != null) {
      return SizedBox(
        height: 230,
        width: double.infinity,
        child: Image(
          image: FileImage(File(_imageFile!.path)),
          fit: BoxFit.fill,
        ),
      );
    }

    return InkWell(
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
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConstants.kFormBorderColor,
                      width: 1,
                    ),
                    color: ColorConstants.kAppBackgroundColor),
              ),
            ),
            const Icon(
              Icons.add,
              color: ColorConstants.kSecondaryTextColor,
              size: 35,
            )
          ],
        ));
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
      _imageFile = pickedFile;
    }
    setState(() {});

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      _imageFile = pickedFile;
    }
    setState(() {});
    Navigator.pop(context);
  }

  Widget buildInputFormFieldWithIcon(
    context,
    Widget title,
    Widget suffixImage,
    TextEditingController controller, {
    void Function(String)? onChanged,
    void Function()? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title,
        const SizedBox(height: 10),
        TextFormField(
          readOnly: true,
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          cursorColor: ColorConstants.kTextPrimaryColor,
          decoration: kTextFieldDecoration.copyWith(suffixIcon: suffixImage),
          style: kTextFieldStyle,
          textAlignVertical: TextAlignVertical.center,
          validator: Validator.validateDate,
        ),
      ],
    );
  }

  void _onSavePressed() async {
    if ((_formKey.currentState?.validate() ?? false)) {
      _vehicleDetailModel.date = _entryDate;
      _vehicleDetailModel.vin = _vinController.text;
      _vehicleDetailModel.vehicleMake = _vehicleMakeController.text;
      _vehicleDetailModel.vehicleModel = _vehicleModelController.text;

      if (await _checkIfVinExists()) {
        showAlertDialog(context, 'Error', 'VIN already exists');
        return;
      }

      if (_vehicleUrl.isEmpty) {
        if (_imageFile != null) {
          try {
            await _uploadImage();
          } on FirebaseException catch (e) {
            showAlertDialog(context, 'Error', e.toString());
            return;
          }
        }
      }

      _vehicleDetailModel.vehiclePhotoUrl = _vehicleUrl;

      try {
        await FirebaseFirestore.instance
            .collection('vehicles')
            .doc(_vinController.text)
            .set(_vehicleDetailModel.toJSON(), SetOptions(merge: true));
      } on Exception catch (e) {
        showAlertDialog(context, 'Error', e.toString());
      }

      Navigator.pop(context);
    } else {
      showAlertDialog(context, 'Error', 'Please verify the field(s)');
    }
  }

  Future<void> _uploadImage() async {
    final file = File(_imageFile!.path);
    final imageName =
        '${_vinController.text}${path.extension(_imageFile!.path)}';
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$imageName');

    final uploadTask = await firebaseStorageRef.putFile(file);
    final fileURL = await uploadTask.ref.getDownloadURL();
    _vehicleUrl = fileURL;
  }

  void _onCalendarPressed() async {
    DateTime today = DateTime.now();
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 100));
    var date = await showRoundedDatePicker(
      height: 300,
      context: context,
      initialDate: _entryDate,
      firstDate: today.subtract(const Duration(days: 365 * 10)),
      lastDate: today.add(const Duration(days: 365 * 3)),
      borderRadius: 16,
      styleDatePicker: MaterialRoundedDatePickerStyle(
          paddingMonthHeader: const EdgeInsets.all(12),
          textStyleMonthYearHeader: TextStyle(
              fontSize: 15,
              color: ColorConstants.kTextPrimaryColor.withOpacity(0.8))),
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

    _dateController.text = DateFormat(' d MMM, ' 'yy').format(local);

    setState(() {});
  }

  Future<bool> _checkIfVinExists() async {
    if (_vinController.text == widget.vehicleDetailModel?.vin) {
      return false;
    }

    var snapshot = await FirebaseFirestore.instance
        .collection('vehicles')
        .doc(_vinController.text)
        .get();

    return snapshot.exists;
  }
}
