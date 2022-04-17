import 'package:email_validator/email_validator.dart';

class Validator {
  static String? validateEmail(String? emailp) {
    String email = emailp ?? 'Invalid';

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
      return 'Invalid';
    }
    if (password.isEmpty) {
      return 'Please enter password';
    }
    if (password.length < 6) {
      return 'Password must be atleast 6 characters';
    }
    return null;
  }

  static String? validateVin(String? vin) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if (vin == null) {
      return 'Invalid';
    }
    if (vin.isEmpty) {
      return 'Please enter VIN';
    }
    if (vin.length != 17) {
      return 'VIN must be exactly 17 characters';
    }

    if (!validCharacters.hasMatch(vin)) {
      return 'Entered VIN contains invalid characters';
    }

    if (vin.toUpperCase().contains('I') ||
        vin.toUpperCase().contains('O') ||
        vin.toUpperCase().contains('U')) {
      return 'VIN cannot contain I, O, U characters';
    }

    return null;
  }

  static String? validateDate(String? date) {
    if (date == null) {
      return 'Invalid';
    }

    if (date.isEmpty) {
      return 'Please enter a date';
    }
    return null;
  }
}
