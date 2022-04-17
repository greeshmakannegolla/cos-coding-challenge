import 'dart:async';
import 'dart:io';

import 'package:caronsale/constants/color_constants.dart';
import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/constants/string_constants.dart';
import 'package:caronsale/constants/style_constants.dart';
import 'package:caronsale/screens/user/change_password_page.dart';
import 'package:caronsale/screens/user/login_page.dart';
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
  String? imageUploadMode;

  XFile? imageFile;
  String? _profilePicUrl;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(kEmail)
        .snapshots()
        .listen((value) {
      var data = value.data() ?? {};
      var preferredImagePicker = data['preferredImagePicker'];

      if (preferredImagePicker.toLowerCase() == "gallery") {
        _groupValue = 0;
        imageUploadMode = 'gallery';
      } else {
        _groupValue = 1;
        imageUploadMode = 'camera';
      }
      _profilePicUrl = data['profileUrl'];
      if (mounted) {
        setState(() {});
      }
    });
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
                    child: Text("My Profile",
                        style: kHeader.copyWith(fontSize: 22)),
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
              ),
              Center(
                child: Column(
                  children: [
                    (_profilePicUrl != null && _profilePicUrl!.isNotEmpty)
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              _profilePicUrl!,
                            ),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundColor: ColorConstants.kSecondaryTextColor,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                )),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: () async {
                          if (imageUploadMode == 'gallery') {
                            await _openGallery(context);
                          } else {
                            _openCamera(context);
                          }

                          if (imageFile != null) {
                            final file = File(imageFile!.path);
                            final imageName =
                                '${FirebaseAuth.instance.currentUser?.email?.split('@')[0]}${path.extension(imageFile!.path)}';
                            final firebaseStorageRef = FirebaseStorage.instance
                                .ref()
                                .child('profileImage/$imageName');

                            try {
                              final uploadTask =
                                  await firebaseStorageRef.putFile(file);
                              final _fileURL =
                                  await uploadTask.ref.getDownloadURL();

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(kEmail)
                                  .update({'profileUrl': _fileURL});
                            } on FirebaseException catch (e) {
                              showAlertDialog(context, 'Error', e.toString());
                            }
                          }
                        },
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
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            ColorConstants.kActionButtonColor),
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.95, 55)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()),
                      );
                    },
                    child: Text(
                      "Change Password",
                      style: kHeader.copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            ColorConstants.kActionButtonColor),
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.95, 55)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (ctx) => const LoginPage()),
                            (Route<dynamic> route) => false);
                      } on FirebaseException catch (e) {
                        showAlertDialog(context, 'Error', e.toString());
                      }
                    },
                    child: Text(
                      "Logout",
                      style: kHeader.copyWith(fontSize: 20),
                    ),
                  ),
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

    FirebaseFirestore.instance.collection('users').doc(kEmail).update({
      'preferredImagePicker': (_groupValue == 0) ? 'gallery' : 'camera'
    }); //TODO: Check if profile url also updates on change
  }

  Future<void> _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = pickedFile;
    }
    //setState(() {});
  }

  Future<void> _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      imageFile = pickedFile;
    }
    //setState(() {});
  }
}
