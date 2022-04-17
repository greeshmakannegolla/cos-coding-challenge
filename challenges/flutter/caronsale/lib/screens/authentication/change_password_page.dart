import 'package:caronsale/helpers/color_constants.dart';
import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:caronsale/helpers/widgets/password_field.dart';
import 'package:caronsale/helpers/widgets/text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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
            floatingActionButton:
                CosTextButton(onPressed: _onSavePressed, title: "SAVE"),
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
                      CosPasswordField(
                        title: 'CURRENT PASSWORD',
                        controller: _currentPasswordController,
                        textInputAction: TextInputAction.next,
                        showAsMandatory: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CosPasswordField(
                        title: 'NEW PASSWORD',
                        controller: _newPasswordController,
                        textInputAction: TextInputAction.next,
                        showAsMandatory: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CosPasswordField(
                        title: 'CONFIRM PASSWORD',
                        controller: _confirmNewPasswordController,
                        showAsMandatory: true,
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }

  void _onSavePressed() async {
    if ((_formKey.currentState?.validate() ?? false) &&
        (_confirmNewPasswordController.text == _newPasswordController.text)) {
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
  }
}
