import 'package:caronsale/helpers/color_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/helper_functions.dart';
import '../../helpers/style_constants.dart';
import '../../helpers/validator.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _hidePassword = true;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

  @override
  dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();

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
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 40),
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
                            child: Text("Change Password",
                                style: kHeader.copyWith(fontSize: 22)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      _buildInputField(
                          context,
                          Row(
                            children: [
                              const Text(
                                'CURRENT PASSWORD',
                                style: kInputformHeader,
                              ),
                              getMandatoryStar()
                            ],
                          ),
                          true,
                          _currentPasswordController,
                          TextInputAction.next,
                          validator: Validator.validatePassword,
                          decoration: kTextFieldDecoration.copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: ColorConstants.kSecondaryTextColor),
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildInputField(
                          context,
                          Row(
                            children: [
                              const Text(
                                'NEW PASSWORD',
                                style: kInputformHeader,
                              ),
                              getMandatoryStar()
                            ],
                          ),
                          true,
                          _newPasswordController,
                          TextInputAction.next,
                          validator: Validator.validatePassword,
                          decoration: kTextFieldDecoration.copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: ColorConstants.kSecondaryTextColor),
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildInputField(
                          context,
                          Row(
                            children: [
                              const Text(
                                'CONFIRM PASSWORD',
                                style: kInputformHeader,
                              ),
                              getMandatoryStar()
                            ],
                          ),
                          true,
                          _confirmNewPasswordController,
                          TextInputAction.done,
                          validator: Validator.validatePassword,
                          decoration: kTextFieldDecoration.copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: ColorConstants.kSecondaryTextColor),
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                            ),
                          )),
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget _buildInputField(
    context,
    Widget title,
    bool isPasswordField,
    TextEditingController controller,
    TextInputAction textInputAction, {
    String? Function(String?)? validator,
    InputDecoration decoration = kTextFieldDecoration,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title,
        const SizedBox(height: 10),
        TextFormField(
          autocorrect: false,
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: isPasswordField ? _hidePassword : false,
          cursorColor: ColorConstants.kTextPrimaryColor,
          validator: validator,
          decoration: decoration,
          style: kTextFieldStyle,
          textAlignVertical: TextAlignVertical.center,
        ),
      ],
    );
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
        onPressed: () async {
          if ((_formKey.currentState?.validate() ?? false) &&
              (_confirmNewPasswordController.text ==
                  _newPasswordController.text)) {
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: FirebaseAuth.instance.currentUser?.email ?? '',
                  password: _currentPasswordController.text);
              FirebaseAuth.instance.currentUser
                  ?.updatePassword(_newPasswordController.text);

              var snackBar =
                  const SnackBar(content: Text('Password reset successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Navigator.pop(context);
            } on FirebaseException catch (e) {
              showAlertDialog(context, "Error", e.toString());
            }
          } else if (_confirmNewPasswordController.text !=
              _newPasswordController.text) {
            showAlertDialog(
              context,
              'Error',
              "New password and confirm password do not match",
            );
          }
        });
  }
}
