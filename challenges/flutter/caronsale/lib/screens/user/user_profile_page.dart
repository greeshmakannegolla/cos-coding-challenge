import 'dart:async';
import 'dart:io';

import 'package:caronsale/constants/color_constants.dart';
import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/constants/string_constants.dart';
import 'package:caronsale/constants/style_constants.dart';
import 'package:caronsale/screens/user/change_password_page.dart';
import 'package:caronsale/screens/user/login_page.dart';
import 'package:caronsale/widgets/app_bar.dart';
import 'package:caronsale/widgets/avatar.dart';
import 'package:caronsale/widgets/text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int? _groupValue;
  String? _imageUploadMode;

  XFile? _imageFile;
  String? _profilePicUrl;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(kEmail)
        .snapshots()
        .listen(_onUserChanged);
  }

  _onUserChanged(value) {
    var data = value.data() ?? {};
    var preferredImagePicker = data['preferredImagePicker'];

    if (preferredImagePicker.toLowerCase() == "gallery") {
      _groupValue = 0;
      _imageUploadMode = 'gallery';
    } else {
      _groupValue = 1;
      _imageUploadMode = 'camera';
    }
    _profilePicUrl = data['profileUrl'];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.kAppBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 30, 12, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CosAppBar(title: "My Profile"),
              const SizedBox(
                height: 45,
              ),
              Center(
                child: Column(
                  children: [
                    Avatar(
                      radius: 60,
                      url: _profilePicUrl,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: _editProfilePhoto,
                        child: const Text(
                          'Change profile photo',
                          style: kUnderlineHeader,
                        )),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EMAIL: ",
                        style: kHeader.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser?.email ?? '',
                        style: kHeader.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PREFERRED IMAGE UPLOAD MODE: ",
                        style: kHeader.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                              value: 0,
                              groupValue: _groupValue,
                              onChanged: _onRadioButtonChanged),
                          Text(
                            'Gallery',
                            style: kHeader.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          Radio(
                              value: 1,
                              groupValue: _groupValue,
                              onChanged: _onRadioButtonChanged),
                          Text(
                            'Camera',
                            style: kHeader.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  CosTextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage()),
                        );
                      },
                      title: "Change Password"),
                  const SizedBox(
                    height: 20,
                  ),
                  CosTextButton(onPressed: _onLogoutPressed, title: "Logout"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRadioButtonChanged(index) {
    setState(() {
      _groupValue = index as int?;
    });

    FirebaseFirestore.instance.collection('users').doc(kEmail).update(
        {'preferredImagePicker': (_groupValue == 0) ? 'gallery' : 'camera'});
  }

  Future<void> _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _imageFile = pickedFile;
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      _imageFile = pickedFile;
    }
  }

  void _editProfilePhoto() async {
    if (_imageUploadMode == 'gallery') {
      await _openGallery(context);
    } else {
      await _openCamera(context);
    }

    if (_imageFile != null) {
      final file = File(_imageFile!.path);
      final imageName =
          '${FirebaseAuth.instance.currentUser?.email?.split('@')[0]}${path.extension(_imageFile!.path)}';
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profileImage/$imageName');

      try {
        final uploadTask = await firebaseStorageRef.putFile(file);
        final _fileURL = await uploadTask.ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(kEmail)
            .update({'profileUrl': _fileURL});
      } on FirebaseException catch (e) {
        showAlertDialog(context, 'Error', e.toString());
      }
    }
  }

  void _onLogoutPressed() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const LoginPage()),
          (Route<dynamic> route) => false);
    } on FirebaseException catch (e) {
      showAlertDialog(context, 'Error', e.toString());
    }
  }
}
