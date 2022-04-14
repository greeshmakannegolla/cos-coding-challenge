import 'package:email_validator/email_validator.dart';

class Validator {
  static String? validateEmail(String? emailp) {
    String email = emailp ?? '';
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    bool isValid = EmailValidator.validate(email.toLowerCase());
    if (isValid == false) {
      return 'Invalid email';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Please enter password';
    }
    if (password.length < 6) {
      return 'Password must be atleast 6 characters';
    }
    return null;
  }
}
