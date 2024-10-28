import 'package:flutter/material.dart';


class Validators {
  static String? validateFullName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your FullName";
    }
    return null;
  }

  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "please Enter Your Name";
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword, BuildContext context) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Please Confirm Your Password";
    }
    if (password != confirmPassword) {
      return "Password Does Not Match";
    }
    return null;
  }

  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Please Enter Email";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Invalid Email";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Please enter a phone number";
    }
    if (!RegExp(r'^\d{11}$').hasMatch(value)) {
      return "Please enter a valid phone number";
    }
    return null;
  }
}
