import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/helpers/validator.dart';
import 'package:caronsale/widgets/password_field.dart';
import 'package:caronsale/widgets/text_button.dart';
import 'package:caronsale/widgets/text_field.dart';
import 'package:caronsale/screens/vehicle/vehicle_overview_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
          backgroundColor: Colors.grey[400],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CosTextField(
                        title: 'EMAIL',
                        controller: _emailController,
                        validator: Validator.validateEmail,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CosPasswordField(
                          title: 'PASSWORD', controller: _passwordController),
                      const SizedBox(
                        height: 60,
                      ),
                      CosTextButton(
                          onPressed: (() {
                            _onLoginPressed(context);
                          }),
                          title: 'LOGIN')
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onLoginPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VehicleOverviewPage()),
        );
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, 'Error', e.code);
      }
    }
  }
}
