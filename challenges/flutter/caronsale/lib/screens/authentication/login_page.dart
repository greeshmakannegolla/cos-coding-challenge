import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/helpers/validator.dart';
import 'package:caronsale/helpers/widgets/password_field.dart';
import 'package:caronsale/helpers/widgets/text_button.dart';
import 'package:caronsale/helpers/widgets/text_field.dart';
import 'package:caronsale/screens/vehicle_inspection_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                      CosTextButton(onPressed: _onLoginPressed, title: 'LOGIN')
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

  _onLoginPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const VehicleInspectionList()),
        );
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, 'Error', e.code);
      }
    }
  }
}
