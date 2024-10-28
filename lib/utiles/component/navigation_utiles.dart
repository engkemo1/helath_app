import 'package:flutter/material.dart';

class NavigationUtils {
  // Push a new screen
  static void push(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  // Replace current screen with a new screen
  static void pushReplacement(BuildContext context, Widget destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  // Push a new screen and remove all previous screens
  static void pushAndRemoveUntil(BuildContext context, Widget destination) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
          (route) => false,
    );
  }

  // Pop the current screen
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}