import 'package:intl/intl.dart';

class ValidationHelper {
  // Name validation
  static String? nameValidation(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (name.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim())) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  static String? pinCodeValidation(String? pinCode) {
    if (pinCode == null || pinCode.trim().isEmpty) {
      return 'Pincode is required';
    }
    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(pinCode)) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  static String? dateValidation(String? date) {
    if (date == null || date.isEmpty) {
      return 'Date of Birth cannot be empty';
    }

    // Date format: DD/MM/YYYY (Indian format)
    String datePattern =
        r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/(19|20)\d{2}$';

    if (!RegExp(datePattern).hasMatch(date)) {
      return 'Enter a valid DOB (DD/MM/YYYY)';
    }

    try {
      DateFormat format = DateFormat('dd/MM/yyyy'); // Parse date
      DateTime parsedDate = format.parseStrict(date);
    } catch (e) {
      return 'Invalid date format (Use DD/MM/YYYY)';
    }

    return null; // ✅ Valid DOB
  }

  // Password validation
  static String? passwordValidation(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[@$!%*?&]').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? passwordMatchValidation(
      String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? emailValidation(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email cannot be empty';
    }

    // Normalize email by converting it to lowercase
    email = email.trim().toLowerCase();

    // Regular expression for email validation
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null; // No error
  }

  // Phone number validation
  static String? phoneNumberValidation(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (phoneNumber.length != 10) {
      return 'Phone number must be 10 digits';
    }
    String phonePattern = r'^[6-9]\d{9}$';
    if (!RegExp(phonePattern).hasMatch(phoneNumber)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  // Account number validation
  static String? accountNumberValidation(String accountNumber) {
    if (accountNumber.isEmpty) {
      return 'Account number cannot be empty';
    }
    if (!RegExp(r'^\d{9,18}$').hasMatch(accountNumber)) {
      return 'Enter a valid account number (9-18 digits)';
    }
    return null;
  }

  // IFSC code validation
  static String? ifscCodeValidation(String ifscCode) {
    if (ifscCode.isEmpty) {
      return 'IFSC code cannot be empty';
    }
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifscCode)) {
      return 'Enter a valid IFSC code';
    }
    return null;
  }

  // Normal validation (input limit)
  static String? normalValidation(String input) {
    if (input.isEmpty) {
      return 'This field cannot be empty';
    }
    if (input.length > 255) {
      return 'Input cannot exceed 25 characters';
    }
    return null;
  }

  // Address validation
  static String? addressValidation(String input) {
    if (input.isEmpty) {
      return 'Address field cannot be empty';
    }

    if (input.length < 10) {
      return 'Please Enter Full Address';
    }
    return null;
  }
}
