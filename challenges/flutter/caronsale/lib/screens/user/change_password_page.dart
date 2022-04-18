import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/widgets/app_bar.dart';
import 'package:caronsale/widgets/password_field.dart';
import 'package:caronsale/widgets/text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

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
            floatingActionButton: CosTextButton(
                onPressed: () {
                  _onSavePressed(context);
                },
                title: "SAVE"),
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
                      const CosAppBar(title: "Change Password"),
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

  void _onSavePressed(BuildContext context) async {
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
