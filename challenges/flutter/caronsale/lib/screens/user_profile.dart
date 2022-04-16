import 'package:caronsale/helpers/color_constants.dart';
import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:caronsale/screens/change_password.dart';
import 'package:caronsale/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int? _groupValue;

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
                  children: const [
                    // Global.currentUser.imageUrl.isNotEmpty
                    //     ?
                    //     CircleAvatar(
                    //         radius: 50,
                    //         backgroundImage: CachedNetworkImageProvider(
                    //             Global.currentUser.imageUrl),
                    //       )
                    //     :
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors
                          .blue, //TODO: Fetch from Firebase and give default icon if no image

                      // backgroundImage: AssetImage(propertyPlaceholder),
                    ),
                    SizedBox(
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
                              onChanged: (index) {
                                setState(() {
                                  _groupValue = index as int?;
                                });
                              }),
                          Text(
                            'Gallery',
                            style: kHeader.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          Radio(
                              value: 1,
                              groupValue: _groupValue,
                              onChanged: (index) {
                                setState(() {
                                  _groupValue = index as int?;
                                });
                              }),
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
                            builder: (context) => const ChangePassword()),
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
}
