import 'package:caronsale/helpers/color_constants.dart';
import 'package:caronsale/helpers/helper_functions.dart';
import 'package:caronsale/helpers/style_constants.dart';
import 'package:caronsale/helpers/validator.dart';
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

  bool hidePassword = true;

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
                      _buildInputField(context, 'EMAIL', false,
                          _emailController, TextInputAction.next,
                          validator: Validator.validateEmail),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildInputField(context, 'PASSWORD', true,
                          _passwordController, TextInputAction.done,
                          validator: Validator.validatePassword,
                          decoration: kLoginTextFieldDecoration.copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                  hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: ColorConstants.kTextPrimaryColor),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                          )),
                      const SizedBox(
                        height: 60,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorConstants.kActionButtonColor),
                              fixedSize: MaterialStateProperty.all(Size(
                                  MediaQuery.of(context).size.width * 0.95,
                                  55)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 3),
                            child: Text(
                              'LOGIN',
                              style: kSubHeader.copyWith(
                                  color: ColorConstants.kTextPrimaryColor),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const VehicleInspectionList()),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  showAlertDialog(context, 'Error',
                                      'No user found for that email');
                                } else if (e.code == 'wrong-password') {
                                  showAlertDialog(context, 'Error',
                                      'Wrong password provided for that user');
                                }
                              }
                            }
                          })
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

  Widget _buildInputField(context, String title, bool isPasswordField,
      TextEditingController controller, TextInputAction textInputAction,
      {InputDecoration decoration = kLoginTextFieldDecoration,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLoginTextTitleStyle,
        ),
        const SizedBox(height: 10),
        TextFormField(
          textInputAction: textInputAction,
          controller: controller,
          keyboardType:
              isPasswordField ? TextInputType.text : TextInputType.emailAddress,
          obscureText: isPasswordField ? hidePassword : false,
          cursorColor: ColorConstants.kTextPrimaryColor,
          decoration: decoration,
          style: kLoginTextFieldStyle,
          textAlignVertical: TextAlignVertical.center,
          validator: validator,
          autocorrect: false,
        ),
      ],
    );
  }
}
